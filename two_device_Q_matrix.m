function [V_matrix, U_matrix] = two_device_Q_matrix(A_hat, N_window, N_CS, P_arrive, lambda)
%% function
% [V_matrix, U_matrix] = two_device_Q_matrix(A_hat, N_window, N_CS, P_arrive)
N_action = 4;
% ----------- There are in total 3 actions: -----------  
% -------- Action 1: stay idle        -----------------
% -------- Action 2: update file 1    -----------------
% -------- Action 3: update file 2    -----------------
% -----------------------------------------------------

% Value functions
T_window = N_window*2;
V_matrix = zeros(A_hat, A_hat, N_CS^T_window, N_action);
U_matrix = zeros(A_hat, A_hat, N_CS^T_window);
V_matrix_copy = zeros(size(V_matrix));

for i_iter = 1:100
    for i_A_1 = 1:A_hat
        for i_A_2 = 1:A_hat
            for i_current_state = 1:N_CS^T_window
                
            % First extract the parameters for the windows
                T_window_index = state_2_vec(i_current_state-1, N_CS, T_window);
                window_index_1 = T_window_index(1:N_window);
                window_index_2 = T_window_index(N_window+1:end);
                
                next_window_index_1 = window_index_1(2:end);
                next_window_index_2 = window_index_2(2:end);
                
                V_matrix(i_A_1, i_A_2, i_current_state, :) = ((window_index_1(1)-1)*i_A_1+(window_index_2(1)-1)*i_A_2)/sum(P_arrive);
                
                for i_action = 1:N_action
                    if i_action == 1
                        i_A_next_1 = min(A_hat, i_A_1+1);
                        i_A_next_2 = min(A_hat, i_A_2+1);
                    elseif i_action == 2
                        i_A_next_1 = 1;
                        i_A_next_2 = min(A_hat, i_A_2+1);
                        V_matrix(i_A_1, i_A_2, i_current_state, i_action) = V_matrix(i_A_1, i_A_2, i_current_state, i_action) + lambda;
                    else
                        i_A_next_1 = min(A_hat, i_A_1+1);
                        i_A_next_2 = 1;
                        V_matrix(i_A_1, i_A_2, i_current_state, i_action) = V_matrix(i_A_1, i_A_2, i_current_state, i_action) + lambda;
                    end
                    
                    for i_G_t_1 = 1:N_CS
                        for i_G_t_2 = 1:N_CS
                            num_1 = i_G_t_1 - 1;
                            num_2 = i_G_t_2 - 1;
                            P_Gt = 0;
                            if num_1 + num_2 <= N_CS - 1
                                P_Gt = nchoosek(N_CS-1, num_1)*P_arrive(1)^(num_1)*(1-P_arrive(1))^(N_CS-1-num_1)*...
                                    nchoosek(N_CS-1-num_1, num_2)*P_arrive(2)^(num_2)*(1-P_arrive(2))^(N_CS-1-num_1-num_2);
                            end
                            linear_index = vec_2_state([next_window_index_1, i_G_t_1, next_window_index_2, i_G_t_2], N_CS);
                            V_matrix(i_A_1, i_A_2, i_current_state, i_action) = V_matrix(i_A_1, i_A_2, i_current_state, i_action)+P_Gt*min(V_matrix_copy(i_A_next_1, i_A_next_2, linear_index, :)) ;
                        end
                    end
                end
                
                [~, min_index] = min(V_matrix(i_A_1, i_A_2, i_current_state, :));%
                U_matrix(i_A_1, i_A_2, i_current_state) = min_index;
            end
        end
        
    end
    V_matrix_copy = V_matrix- V_matrix(1,1,1);
    i_iter
end

end
