function [total,argmax,val_max] = viterbi_decode(obs,states,init_prob,trans_prob,emission_prob)
   T = {};
   for state = 1:length(states)
       T{state} = {init_prob(state),states(state),init_prob(state)};
   end
   for out = 1:length(obs)
       U = {};
       for following_state = 1:length(states)
           total = 0;
           argmax = [];
           val_max = 0;
           for source_state = 1:length(states)
               Ti = T{source_state};
               prob = Ti{1}; v_path = Ti{2}; vit_prob = Ti{3};
               p = emission_prob(source_state,obs(out)) * trans_prob(source_state,following_state);
               prob = prob*p;
               vit_prob = vit_prob*p;
               total = total + prob;
               if vit_prob > val_max
                   argmax = [v_path, states(following_state)];
                   val_max = vit_prob;
               end
           end
           U{following_state} = {total,argmax,val_max};
       end
       T = U;
   end
   total = 0;
   argmax = [];
   val_max = 0;
   for state = 1:length(states)
       Ti = T{state};
       prob = Ti{1}; v_path = Ti{2}; vit_prob = Ti{3};
       total = total + prob;
       if vit_prob > val_max
           argmax = v_path;
           val_max = vit_prob;
       end
   end
end
