function [V_matrix_merged, U_matrix_merged] = merge_optimal_action(V_matrix_vec)
[A_hat, N_index, N_action, N_files] = size(V_matrix_vec);
M_action = N_files + 1;
V_matrix_merged = zeros(A_hat, A_hat, N_index^2, M_action);
U_matrix_merged = zeros(A_hat, A_hat, N_index^2);

N_window = log2(N_index);

for i_A_1 = 1:A_hat
    for i_A_2 = 1:A_hat
        for i_index = 1:N_index^2
            
            window_vector = state_2_vec(i_index-1, N_action, N_window*2);
            window_vector_1 = window_vector(1:N_window);
            window_vector_2 = window_vector(N_window+1:end);
            
            state_1 = vec_2_state(window_vector_1, N_action);
            state_2 = vec_2_state(window_vector_2, N_action);
            
            V_matrix_merged(i_A_1, i_A_2, i_index, 1) = V_matrix_vec(i_A_1, state_1, 1, 1)+V_matrix_vec(i_A_2, state_2, 1, 2);
            V_matrix_merged(i_A_1, i_A_2, i_index, 2) = V_matrix_vec(i_A_1, state_1, 2, 1)+V_matrix_vec(i_A_2, state_2, 1, 2);
            V_matrix_merged(i_A_1, i_A_2, i_index, 3) = V_matrix_vec(i_A_1, state_1, 1, 1)+V_matrix_vec(i_A_2, state_2, 2, 2);
            
            [~, min_loc] = min(V_matrix_merged(i_A_1, i_A_2, i_index, :));
            
            U_matrix_merged(i_A_1, i_A_2, i_index) = min_loc;
        end
    end
end
end
