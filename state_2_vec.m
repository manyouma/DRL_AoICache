function output =  state_2_vec(state, N_ary, output_size)
output = ones(1, output_size);
remainder = state;
for i_output = 1:output_size
    if remainder >= N_ary^(output_size-i_output)
        output(i_output) = floor(remainder/(N_ary^(output_size-i_output)))+1;
        remainder = remainder-(output(i_output)-1)*N_ary^(output_size-i_output);
    else
        output(i_output) = 1;
    end
end
end