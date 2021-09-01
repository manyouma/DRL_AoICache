function output = vec_2_state(vector, N_ary)

input_size = max(size(vector));
output = sum((vector-1).*N_ary.^((input_size:-1:1)-1))+1;

end