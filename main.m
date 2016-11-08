clear all;
%Loading the data of subject-1 ADL-5
load S1-ADL5.dat;
for i=1:34
    x(:,i) = S1_ADL5(:,i);
end
no_rows=size(x,1);
%Taking mean values for a sliding window of 500ms
for col=1:34
    cnt=1;
    for i=1:7:no_rows
        if (i+16) <= no_rows
            means(cnt,col)=mean(x(i:i+15,col));
            cnt=cnt+1;
        end
    end
end
cnt=1;
labels(:,1) = S1_ADL5(:,245);                   %245 for higher level activity
for i=1:7:no_rows
    if (i+16) <= no_rows
            label_mean(cnt)= mode(labels(i:i+15,1));
            cnt=cnt+1;
    end
end

%Interpolation for the missing data:
interpolated=zeros(size(means,1),size(means,2));
for col=1:34
    for i=1:size(means,1)
        chk1 = isnan(means(i,col));
        if chk1
            if i==1
                chk2 = isnan(interpolated(i+1,col));  
                if chk2 == 0
                    interpolated(i,col)=interpolated(i+1,col);
                end
            else
                chk2 = isnan(interpolated(i-1,col));  
                if chk2 == 0
                    interpolated(i,col)=interpolated(i-1,col);
                end
            end
        else
            interpolated(i,col)=means(i,col);
        end
    end
end
%Finding the transition matrix
possible_labels=unique(label_mean);
transition_counts=zeros(size(possible_labels,2),size(possible_labels,2));

for i=1:size(possible_labels,2)
    current_label=possible_labels(i);
    for cnt=1:size(possible_labels,2)
        next_label=possible_labels(cnt);
        for j=1:(size(label_mean,2)-1)
            if (label_mean(j)== current_label) 
                if (label_mean(j+1)== next_label)
                    transition_counts(i,cnt)=transition_counts(i,cnt)+1;
                end
            end
        end
    end
end
%Finding the transition probability and the initial probability
transition_probabilities=transition_counts;
initial_probability=zeros(6,1);
for i=1:size(transition_counts,1)
    transition_probabilities(i,:)=transition_counts(i,:)/sum(transition_counts(i,:));
    initial_probability(i,1)= sum(transition_counts(i,:))/(size(label_mean,2)-1);
end
%Kmeans clustering
normalised_counts=zeros(size(means,1),size(means,2));
cluster_cnt = 13;
for col_no = 1:34
 normalised_counts(:,col_no)=kmeans(interpolated(:,col_no),cluster_cnt);   
end

%Emission Probability
emission_counts=zeros(cluster_cnt,size(possible_labels,2),size(means,2));
for col_no = 1:34
    possible_sensor_values=1:cluster_cnt;
    for row_no = 1:size(normalised_counts,1)
        for value_cnt=1:size(possible_sensor_values,2)
            current_sensor_value=possible_sensor_values(value_cnt);
            for state_cnt=1:size(possible_labels,2)
                current_label=possible_labels(state_cnt);
                if normalised_counts(row_no,col_no)== current_sensor_value
                    if (label_mean(row_no)== current_label)
                        emission_counts(value_cnt,state_cnt,col_no) = emission_counts(value_cnt,state_cnt,col_no)+1;
                    end
                end
            end
        end
    end
end

activity_instances=zeros(1,size(possible_labels,2));
for i=1:size(activity_instances,2)
    activity_instances(i)=size(find(label_mean==possible_labels(i)),2);
end

for state_cnt=1:size(possible_labels,2)
    emission_counts(:,state_cnt,:)=emission_counts(:,state_cnt,:)/activity_instances(state_cnt);
end
probability_value=unique(emission_counts);
new_least_value=probability_value(2);
emission_counts(find(emission_counts==0))=new_least_value;
emission_counts=log(emission_counts);

emission_prob=zeros(cluster_cnt,size(possible_labels,2));
 
for row_no = 1:13
    for state_cnt=1:size(possible_labels,2)
         emission_prob(row_no,state_cnt)=sum(emission_counts(row_no,state_cnt,:));
    end
end
emission_prob=0-emission_prob;

probability_values=unique(initial_probability);
new_least_value=probability_values(2);
initial_probability(find(initial_probability==0))=new_least_value;
initial_probability=0-log(initial_probability);

probability_valu=unique(transition_probabilities);
new_least_value=probability_valu(2);
transition_probabilities(find(transition_probabilities==0))=new_least_value;
transition_probabilities=0-log(transition_probabilities);

outputs=zeros(1,size(normalised_counts,1));
for i=1:size(normalised_counts,1)
    outputs(i)=mean(normalised_counts(i,:));
end
outputs=int8(outputs);

% Calling the Viterbi function
[total, argmax, valmax] = viterbi_decode(outputs,possible_labels,transpose(initial_probability),transition_probabilities,transpose(emission_prob));
argmax(end)=[];
% Checking the accuracy
accuracy =100*(size(find(label_mean==argmax))/size(label_mean,2));
disp('Accuracy')
disp(accuracy);
