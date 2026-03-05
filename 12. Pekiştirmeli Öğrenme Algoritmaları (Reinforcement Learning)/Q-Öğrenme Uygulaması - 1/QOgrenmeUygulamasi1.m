%% GridWorld (4x4)

% 4x4 GridWorld
% 1 = sol üst köşe, 16 = sağ alt köşe (hedef).
nStates = 16;   

nActions = 4;   
actions = [-4, 4, -1, 1];  

goalState = 16; % Hedef = sağ alt köşe

% 2. Q TABLOSU
Q = zeros(nStates, nActions);

alpha = 0.1;     % Öğrenme oranı (yeni bilginin ağırlığı)
gamma = 0.9;     % Gelecekteki ödül katsayısı (discount factor)
epsilon = 0.2;   % Keşif oranı (epsilon-greedy)
episodes = 300;  % Eğitim tekrar sayısı (kaç bölüm oynanacak)

rewards_history = zeros(episodes,1); % her bölümde toplam ödül


for ep = 1:episodes
    state = 1;      % Her bölüm başında başlangıç = sol üst köşe
    totalReward = 0; % Bu bölümde elde edilen toplam ödül
    
    while state ~= goalState
        
        if rand < epsilon
            % Rastgele seçim (keşif)
            action = randi(nActions); 
        else
            [~, action] = max(Q(state,:));
        end
        
        newState = state + actions(action);
        
        if newState < 1 || newState > nStates
            newState = state;  % Eğer dışarı çıkarsa aynı yerde kal
        elseif mod(state,4)==1 && action==3
            % Sol kenardaysa SOL'a gidemez
            newState = state;
        elseif mod(state,4)==0 && action==4
            % Sağ kenardaysa SAĞ'a gidemez
            newState = state;
        end
        
        % --- Ödül Fonksiyonu ---
        % Hedefe ulaşırsa = +10, aksi halde her adımda = -1 (ceza)
        reward = (newState == goalState)*10 - 1;
        totalReward = totalReward + reward; % toplam ödüle ekle
        
        % --- Q-Learning Güncellemesi ---
        % Q(s,a) = Q(s,a) + α * [r + γ*maxQ(s',:) - Q(s,a)]
        Q(state,action) = Q(state,action) + alpha * ...
            (reward + gamma*max(Q(newState,:)) - Q(state,action));
        
        state = newState;
    end
    
    rewards_history(ep) = totalReward;
end


disp('Q tablosu (yaklaşık):');
disp(round(Q,2));

state = 1; 
path = state;
while state ~= goalState
    [~, action] = max(Q(state,:));  
    state = state + actions(action);
    path(end+1) = state; 
    if numel(path)>20, break; end 
end
fprintf('Öğrenilen yol: '); disp(path);


figure;
plot(rewards_history,'b-','LineWidth',1.5);
xlabel('Bölüm'); ylabel('Toplam Ödül');
title('Q-Learning - Öğrenme Eğrisi (GridWorld 4x4)');
grid on;