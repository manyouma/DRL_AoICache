% ============ Consider the case with One File and One =================
clear all
rng(3)
% Probability of user request arrival: 
P_arrive = 0.3;

%% First we obtain the optimal policy and the Q_function
lambda_matrix = 5:5:30;
average_matrix = zeros(size(lambda_matrix));
cost_matrix = zeros(size(lambda_matrix));
V_value_matrix = zeros(size(lambda_matrix));

for i_lambda = 1:max(size(lambda_matrix))
lambda = lambda_matrix(i_lambda);
A_hat = 50;
N_window = 5;
N_CS = 4; 
[V_matrix, U_matrix] = per_device_Q_matrix(A_hat, N_window, N_CS, P_arrive, lambda);

T = 100010;
[arrival_vector, initial_A] = generate_arrival_vector(T, N_CS, P_arrive, A_hat);
current_A = initial_A;
num_update = 0;
num_service = 0;
total_AoI = 0;

for t = 1:T-N_window    
    current_window = arrival_vector(t:t+N_window-1)';
    current_A_hat = min(A_hat, current_A);
    current_index = vec_2_state(current_window, N_CS);       
    current_action = U_matrix(current_A_hat, current_index);
    
    if current_action == 1
        next_A = min(A_hat, current_A + 1);
    else
        num_update = num_update + 1;
        next_A = 1;
    end
   
    if current_window(1) > 1 
        num_service = num_service + (current_window(1)-1);
        total_AoI = total_AoI + current_A*(current_window(1)-1); 
    end
    current_A = next_A;
end

average_matrix(i_lambda) = (total_AoI)/num_service
cost_matrix(i_lambda) = num_update/T
V_value_matrix(i_lambda) = (total_AoI)/num_service + lambda_matrix(i_lambda)*num_update/T
end

