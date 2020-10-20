function [ M ] = rndAlign( model )

    M = zeros(model.k, max(model.mg));
    
    for i = 1:model.k
        p = randperm(model.N);        
        p = p(1:model.mg(i));
        M(i,1:model.mg(i)) = sort(p);
    end

end

