clc; clear; close all; rng(42);

nStates = 10;          % 1 boyutlu çizgi (10 hücre)
nActions = 2;          % 1=sol, 2=sağ
goalState = 10; 

Q = zeros(nStates, nActions);

alpha = 0.1;       % öğrenme oranı
gamma = 0.9;       % geleceği indirim faktörü
epsilon = 0.2;     % keşif oranı
episodes = 200;    % bölüm sayısı

rewards_history = zeros(episodes,1);

for ep = 1:episodes
    state = 1;          % başlangıç: 1. hücre
    totalReward = 0;
    
    while state ~= goalState
        if rand < epsilon
            action = randi(nActions); % rastgele
        else
            [~, action] = max(Q(state,:)); % en iyi
        end
        
        if action == 1
            newState = max(1, state-1); % sola git
        else
            newState = min(nStates, state+1); % sağa git
        end
        
        % --- ödül
        reward = (newState==goalState)*10 - 1;
        totalReward = totalReward + reward;
        
        % --- Q güncellemesi
        Q(state,action) = Q(state,action) + alpha * ...
            (reward + gamma*max(Q(newState,:)) - Q(state,action));
        
        % yeni duruma geç
        state = newState;
    end
    
    rewards_history(ep) = totalReward;
end


disp('Q tablosu:');
disp(round(Q,2));

state = 1; path = state;
while state ~= goalState
    [~, action] = max(Q(state,:));
    if action == 1
        state = max(1, state-1);
    else
        state = min(nStates, state+1);
    end
    path(end+1) = state;
    if numel(path)>50, break; end
end
fprintf('Öğrenilen yol: '); disp(path);

figure;
plot(rewards_history,'r-','LineWidth',1.5);
xlabel('Bölüm'); ylabel('Toplam Ödül');
title('Q-Learning - 1D Hazine Avı');
grid on;
