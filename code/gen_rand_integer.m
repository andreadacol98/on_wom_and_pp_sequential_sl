function rand_number = gen_rand_integer(range, seed)
% rand_number = gen_rand_integer(n, seed)
%
% rand_number: random integer number in a given range
% range: range of number that we allow
% seed: number of seed for random number generator 

rng(seed);
rand_number = randi(range, 1);

end