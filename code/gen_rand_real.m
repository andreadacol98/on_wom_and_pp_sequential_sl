function rand_number = gen_rand_real(seed)
% rand_number = gen_rand_real(n, seed)
%
% rand_number: random integer number in a given range
% seed: number of seed for random number generator 

rng(seed);
rand_number = rand(1);

end