function ComparissonOfResubmissionDistributions(YMatrix1)
%CREATEFIGURE(YMATRIX1)
%  YMATRIX1:  matrix of y data

% %  Auto-generated by MATLAB on 10-May-2015 12:03:50
% 
% % Create figure
% figure1 = figure;
% 
% % Create axes
% axes1 = axes('Parent',figure1,'XTickLabel',{'0','1','2','3','4','5','6'});
% box(axes1,'on');
% hold(axes1,'on');
% 
% % Create ylabel
% ylabel('Percentage(%)','FontSize',16);
% 
% % Create xlabel
% xlabel(['Submissions';'           '],'FontSize',16);
% 
% % Create title
% title('Submissions until publication','FontSize',16);
% 
% % Create multiple lines using matrix input to plot
% plot1 = plot(YMatrix1);
% set(plot1(1),'DisplayName','Real','Marker','pentagram','LineStyle','--');
% set(plot1(2),'DisplayName','Simulations','Marker','diamond',...
%     'LineStyle','none');
% 
% % Create legend
% legend1 = legend(axes1,'show');
% set(legend1,'FontSize',16);

%  Auto-generated by MATLAB on 19-May-2015 11:13:26

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'XTickLabel',{'0','1','2','3','4','5','6'},...
    'XTick',[1 2 3 4 5 6 7]);
box(axes1,'on');
hold(axes1,'on');

% Create ylabel
ylabel('Percentage (%)','FontSize',16);

% Create xlabel
xlabel('Submissions','FontSize',16);

% Create title
title('Submissions until publication','FontSize',16);

% Create multiple lines using matrix input to bar
bar1 = bar(YMatrix1);
set(bar1(2),'DisplayName','Real');
set(bar1(1),'DisplayName','Simulations',...
    'FaceColor',[0.600000023841858 0.200000002980232 0]);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.722209660400113 0.808442177974105 0.148033126293996 0.0800711743772242],...
    'FontSize',16);


