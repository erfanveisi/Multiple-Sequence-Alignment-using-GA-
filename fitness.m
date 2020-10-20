function [ s ] = fitness( M, model )
    
    global NFE;
    if isempty(NFE)
        NFE = 0;
    end

    NFE = NFE + 1;
    
    mr = mrefine(M, model);
    s  = 0;
    
    for i = 1:model.k - 1
        for j = i + 1:model.k
            for p = 1:model.N
                s = s + model.pam(mr(i,p), mr(j,p));
            end
        end
    end

end

