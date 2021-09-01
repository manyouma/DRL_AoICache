function [V_matrix, U_matrix] = per_device_Q_matrix(A_hat, N_window, N_CS, P_arrive, lambda)
%% function 

N_action = 2;
% Value functions 
V_matrix = zeros(A_hat, N_CS^N_window, N_action);
U_matrix = ones(A_hat, N_CS^N_window);
V_matrix_copy = zeros(size(V_matrix));

%%
for i_iter = 1:4000
    for i_A = 1:A_hat
        for i_current_state = 1:N_CS^N_window
            
            window_index = state_2_vec(i_current_state-1, N_CS, N_window);
            next_window_index = window_index(2:end);
            
            V_matrix(i_A, i_current_state, :) = (window_index(1)-1)*i_A/(P_arrive*(N_CS-1));
            
            for i_action = 1:N_action
                
                if i_action == 1
                    i_A_next = min(A_hat, i_A+1);
                else
                    i_A_next = 1;
                    V_matrix(i_A, i_current_state, i_action) = V_matrix(i_A, i_current_state, i_action) + lambda;
                end
                for i_G_t = 1:N_CS
                    P_Gt = nchoosek(N_CS - 1, i_G_t-1)*P_arrive^(i_G_t-1)*(1-P_arrive)^(N_CS-i_G_t);
                    linear_index = vec_2_state([next_window_index, i_G_t], N_CS);
                    V_matrix(i_A, i_current_state, i_action) = V_matrix(i_A, i_current_state, i_action)+P_Gt*min(V_matrix_copy(i_A_next, linear_index, :)) ;
                end
            end
            
            
            [~, min_index] = min(V_matrix(i_A, i_current_state, :));%
            U_matrix(i_A, i_current_state) = min_index;
            
        end
    end
    V_matrix_copy = V_matrix - V_matrix(1,1);
end

end
