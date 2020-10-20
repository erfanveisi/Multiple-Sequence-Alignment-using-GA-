function [ cM1, cM2 ] = crossover(  M1, M2, model )

    cM1 = M1;
    cM2 = M2;

    rk = randi([1 model.k]);
    cM1(rk,:) = M2(rk,:);
    cM2(rk,:) = M1(rk,:);
        
end

