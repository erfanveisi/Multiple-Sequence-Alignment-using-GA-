function [ mr ] = mrefine( M, model )

    mr = zeros(model.k, model.N);
    
    for i = 1:model.k
        for j = 1:model.mg(i)
            mr(i, M(i,j)) = 21;
        end
    end

    for i = 1:model.k
        cm = 1;
        cn = 1;
        while cm <= model.N
            if (mr(i, cm) == 21)
                cm = cm + 1;
                continue;
            end
            
            mr(i, cm) = find(model.mol == model.X(i, cn));
            cn = cn + 1;
            cm = cm + 1;
        end                
    end
end

