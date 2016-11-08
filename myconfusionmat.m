function confMat=myconfusionmat(v,pv)

yu=unique(v);
confMat=zeros(length(yu));
for i=1:length(yu)
    for j=1:length(yu)
        confMat(i,j)=sum(v==yu(i) & pv==yu(j));
    end
end

%weighted f measure

for i=1:length(yu)

tp(i)=confMat(i,i);

end

for i=1:length(yu)

temp=sum(confMat);

fp(i)=temp(1,i)-confMat(i,i);

end

for i=1:length(yu)

temp=sum(confMat,2);

fn(i)=temp(i,1)-confMat(i,i);

end

for i=1:length(yu)

temp=sum(sum(confMat));

tn(i)=temp-tp(i)-fp(i)-fn(i);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
display(tp)
display(fn)
display(tn)
display(fp)

% Calculating precision and Recall 
for i=1:length(yu)
    precision(i)=tp(i)/(tp(i)+fp(i));
    
    recall(i)=tp(i)/(tp(i)+fn(i));
    
    w(i)=(tp(i)+fn(i))/sum(sum(confMat));
    
    fmeasure(i) = (2*w(i)*precision(i)*recall(i))/(precision(i)+recall(i)) ;
end

% Calculating the weighted F-measure
wfmeasure = sum(fmeasure);

total_tp = sum(tp);
total_tn = sum(tn);
total_fp = sum(fp);
total_fn = sum(fn);

% Plotting the results
% Display four bars for the tp, fn, tn, fp.

y = [total_tp; total_fn; total_tn; total_fp];
bar(y,'r');
hold on
title('Subject 1')
xt = get(gca, 'XTick');
set(gca, 'XTick', xt, 'XTickLabel', {'True Positive' 'False Negative' 'True Negative' 'False Positive'})

display(wfmeasure);

% display ROC TPR Vs FPR

TPR = total_tp/(total_tp+total_fn);
FPR = total_fp/(total_fp+total_tn); 
figure
hold on
plot(FPR,TPR)
xlabel('False Positive Rate')
ylabel('True Positive Rate')
title('Subject 1')

