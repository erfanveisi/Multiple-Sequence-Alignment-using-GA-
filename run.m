clc;
clear;
close all;

load('pam250.mat');

X = [ 'GTCGAC___'
      'ATAGC____'
      'CCAA_____'
      'ATTAG____'
      'GTTTGTTT_'];
  
k = size(X, 1);
m = zeros(k, 1);

for i = 1:k
    m(i) = find(X(i,:) == '_', 1) - 1;
end

beta = 1.25;
N = floor(max(m) * beta);
mg = N - m;

model.X = X;
model.k = k;
model.m = m;
model.N = N;
model.mg = mg;
model.mol = mol;
model.pam = pam;

clear i X k m N mg;

global NFE;
NFE = 0;

%% GA Parameters
gMax = 100;         
nPop = 500;         

pc = 0.8;           
nc = 2 * round(pc * nPop/2);
pm = 0.3;                 
nm = round(pm * nPop);  

%% Initialization

empty_individual.M = [];
empty_individual.fitness = [];

pop = repmat(empty_individual, nPop, 1);

for i = 1:nPop        
    pop(i).M = rndAlign(model);
    pop(i).fitness = fitness(pop(i).M, model);
end

Costs = [pop.fitness];
[Costs, SortOrder] = sort(Costs, 'descend');
pop = pop(SortOrder);

BestSol = pop(1);

BestCost = zeros(gMax, 1);

nfe = zeros(gMax, 1);

%% GA Main Loop

for it = 1:gMax
    p = [pop.fitness] / sum([pop.fitness]);
    c = cumsum(p);   
    
    popm = repmat(empty_individual, nm, 1);
    for i = 1:nm
        i1 = find(rand() <= c, 1, 'first');
        p1 = pop(i1);
        
        popm(i).M = mutate(p1.M, model);
        popm(i).fitness = fitness(popm(i).M, model);
    end
        
    popc = repmat(empty_individual, nc/2, 2);
    for k = 1:nc/2     
        i1 = find(rand() <= c, 1, 'first');
        i2 = find(rand() <= c, 1, 'first');
        p1 = pop(i1);
        p2 = pop(i2);
                
        [popc(k, 1).M, popc(k, 2).M] = crossover(p1.M, p2.M, model);
                
        popc(k, 1).fitness = fitness(popc(k, 1).M, model);
        popc(k, 2).fitness = fitness(popc(k, 2).M, model);
        
    end
    popc = popc(:);
    
    pop = [pop
           popc
           popm];
         
    Costs = [pop.fitness];
    [Costs, SortOrder] = sort(Costs, 'descend');
    pop = pop(SortOrder);
        
    pop = pop(1:nPop);
    Costs = Costs(1:nPop);
        
    BestSol = pop(1);           
    BestCost(it) = BestSol.fitness;
        
    nfe(it) = NFE;
        
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
    
end

%% Results

figure;
plot(nfe,BestCost,'LineWidth',2);
xlabel('NFE');
ylabel('Best Cost');
Aligment = mol(mrefine(BestSol.M, model))
