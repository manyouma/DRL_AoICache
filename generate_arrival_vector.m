function [arrival_file_vector, initial_A] = generate_arrival_vector(T, N_CS, P_arrive, A_hat)

% P_arrival as a vector storing the probability of each arrival event.
% For example, P_arrive = [P_file_1, P_file_2] is the corresponding
% to the popularity for each file 
N_file = max(size(P_arrive));

% First, we simulate the arrivals at each CS separately. Each file has its
% own arrival rates that are stored in the vector P_arrive
arrival_matrix = rand(T, N_CS-1);
arrival_file_vector = zeros(T, N_file);
arrival_vector = zeros(size(arrival_matrix));

% ------------------------------------------------
% Generate the arrival vector
% ------------------------------------------------
arrival_vector(arrival_matrix <= P_arrive(1)) = 1;

for i_file = 2:N_file
    compare_index = (arrival_matrix <= sum(P_arrive(1:i_file))).*(arrival_matrix > sum(P_arrive(1:i_file-1)));
    arrival_vector(compare_index == 1) = i_file;
end


% then calculate the total number of
for i_file = 1:N_file
    arrival_events = (arrival_vector == i_file);
    arrival_file_vector(:, i_file) = sum(arrival_events, 2);
end

% 
arrival_file_vector = arrival_file_vector + 1;
initial_A = floor(rand(1, N_file)*A_hat)+1;






