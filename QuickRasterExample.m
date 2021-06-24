% spM is your spike matrix

[nC,maxSp]=size(spM);
figure;hold on;
for j1=1:nC
    aus = spM(j1,:); aus(isnan(aus))=[];
    plot(aus,j1*ones(size(aus)),'.','MarkerSize',12,'color',[0.7 0.7 0.7]);
end
axis tight;ylim([0.5,nC+0.5]);set(gca,'FontSize',16);
