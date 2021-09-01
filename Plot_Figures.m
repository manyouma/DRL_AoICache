clear all 
close all
lambda_vec = 5:5:30; 

%% Load the data from the MDP-based approach
load delta_5.mat
CMDP_performance = average_matrix + lambda_vec.*cost_matrix;
CMDP_cost = cost_matrix;
CMDP_average = average_matrix;

%% Load the data from the Periodic-based approach
load delta_1.mat
Periodic_performance = average_matrix + lambda_vec.*cost_matrix;
Periodic_cost = cost_matrix;
Periodic_average = average_matrix;

%% Load the data from the DRL-based approach
N_random = 30;
DRL_performance = zeros(max(size(lambda_vec)),N_random);
DRL_cost = zeros(max(size(lambda_vec)),N_random);
DRL_aoi = zeros(max(size(lambda_vec)),N_random);
DRL_convergence = zeros(max(size(lambda_vec)),N_random, 200);
for eta = 5:5:30
    for random_num = 0:N_random-1
        cmd = ['load data/AoI_Eta', num2str(eta), '_Random', num2str(random_num), '_Delta5_N_User2.mat'];
        eval(cmd)
        DRL_convergence(eta/5, random_num+1, :) = convergence_vec;
        DRL_performance(eta/5, random_num+1) = total_cost;
        DRL_cost(eta/5, random_num+1) = mu;
        DRL_aoi(eta/5, random_num+1) = average_aoi;
    end
end
DRL_performance= mean(DRL_performance,2);
DRL_cost = mean(DRL_cost,2);
DRL_aoi = mean(DRL_aoi,2);
DRL_convergence = squeeze(mean(DRL_convergence,2));

%% Plot 3 in the paper
figure(1)
hb = bar(lambda_vec, [CMDP_performance', DRL_performance, Periodic_performance']);
hb(1).FaceColor = 'r';
hb(2).FaceColor = 'b';
hb(3).FaceColor = 'g';
hb(1).EdgeColor = 'r';
hb(2).EdgeColor = 'b';
hb(3).EdgeColor = 'g';
ylim([2,9])
xlabel('$\eta$', 'Interpreter','latex')
ylabel('Average Cost', 'Interpreter','latex')
legend( '$\Delta = 4$ (Optimal)', '$\Delta = 4$ (DQN)', 'Periodic', 'Interpreter','latex')
grid on
 %% Plot 4 in the paper
figure
plot(Periodic_cost, Periodic_average,'g--o',... 
    DRL_cost,DRL_aoi, 'b-d',...
    CMDP_cost,CMDP_average,'r-.s', ...
      'LineWidth', 1.5);

xlabel('Update Frequency [Updates/Time Slot]', 'Interpreter','latex')
ylabel('Average AoI [Time Slots]', 'Interpreter','latex')
legend('Periodic', '$\Delta = 4$ (DQN)', '$\Delta = 4$ (Optimal)',  'Interpreter','latex')
%ylim([1,5])
%xlim([0.1,0.3])
grid on
%% Plot 5 in the paper
figure
plot(1:200,-DRL_convergence(5,:),  'r-.', ...
     1:200,-DRL_convergence(3,:),  'b-',...
     1:200,-DRL_convergence(1,:),'g--',...
 'LineWidth', 1.5); 
xlabel('Episode', 'Interpreter','latex')
ylabel('Average Cost', 'Interpreter','latex')
legend('$\eta = 25$', '$\eta = 15$', '$\eta = 5$',  'Interpreter','latex')
xlim([0,50])
grid on 
 
 