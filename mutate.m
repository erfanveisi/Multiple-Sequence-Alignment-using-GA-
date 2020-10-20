function [ mM ] = mutate( M, model )
    
    mM = M;
    rk = randi([1 model.k]);
    rm = randi([1 model.mg(rk)]);
    
    d = 1:10;
    d(M(rk,1:model.mg(rk))) = [];
    rd = randi([1 numel(d)]);
    
    mM(rk, rm) = d(rd);
    mM(rk, 1:model.mg(rk)) = sort(mM(rk, 1:model.mg(rk)));
end

