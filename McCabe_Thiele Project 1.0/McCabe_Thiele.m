% Givens
xf=0.35;
xD=0.99;
xW=0.01;
options=optimset('display','off');
q=0;
alpha=50;
Effeciency=0.45;

% 45 line
plot([0 1],[0 1],'-k','linewidth',0.2)
xlabel('x'),ylabel('y')
set(gca,'Xlim',[0 1])
set(gca,'Ylim',[0 1])
hold on
grid on

%Equilibrium curve
y_eq=@(x) alpha*x/(1-(1-alpha)*x);
x_eq=@(y) y/(alpha+(1-alpha)*y);
fplot(y_eq,[0 1],'k')

%q-line
q_slope=q/(q-1);
q_intercept=xf/(q-1);

if q>1
    xq2=1;
    yq2=q_slope*xq2-q_intercept;
elseif q==1
    xq2=xf;
    yq2=1;
elseif q<1 && q>0
    xq2=0;
    yq2=q_slope*xq2-q_intercept;
elseif q==0
    xq2=0;
    yq2=xf;
else
    xq2=0;
    yq2=q_slope*xq2-q_intercept;
end
    
plot([xf xq2],[xf yq2],'--k','linewidth',0.1)

% Reflux ratio
if q==1
    x_Rmin=xf;
    y_Rmin=y_eq(x_Rmin);
elseif q==0
    y_Rmin=xf;
    x_Rmin=fsolve(@(x) y_Rmin-alpha*x/(1-(1-alpha)*x),xf,options);
else
    x_Rmin=fsolve(@(x) alpha*x/(1-(1-alpha)*x)-(q_slope*x-q_intercept),0.5,options);
    y_Rmin=y_eq(x_Rmin);
end
R_min=(xD-y_Rmin)/(y_Rmin-x_Rmin);
R=2*R_min;

% Intersection of top section line and q line
if q==1
    x_intersect=xf;
else
    x_intersect=fsolve(@(x) R/(R+1)*x+xD/(R+1)-(q_slope*x-q_intercept),xf,options);
end
y_intersect=R/(R+1)*x_intersect+xD/(R+1);

% Top section line
plot([x_intersect xD],[y_intersect xD],'-k','linewidth',0.5)

% Bottom section line
plot([x_intersect xW],[y_intersect xW],'-k','linewidth',0.5)

%Drawing top section stages
x_top_a=xD;
y_top_a=xD;
x_top_b=xD;
y_top_b=xD;
x_top_c=xD;
y_top_c=xD;
Top_sec_line=@(x) R/(R+1)*x+xD/(R+1);
i=0;

while x_top_a>x_intersect
    
    y_top_b=y_top_a;
    x_top_b=x_eq(y_top_b);
    plot([x_top_a x_top_b],[y_top_a y_top_b],'-r')
    x_top_c=x_top_b;
    y_top_c=Top_sec_line(x_top_c);
    plot([x_top_b x_top_c],[y_top_b y_top_c],'-r')
    x_top_stage_calc=x_top_a;
    x_top_a=x_top_c;
    y_top_a=y_top_c;
    i=i+1;
end
NTS_TOP=i-(x_top_c-x_intersect)/(x_top_c-x_top_stage_calc);

%Drawing Bottom section stages
x_bot_a=xW;
y_bot_a=xW;
x_bot_b=xW;
y_bot_b=xW;
x_bot_c=xW;
y_bot_c=xW;
Bot_sec_slope=(y_intersect-xW)/(x_intersect-xW);
Bot_sec_intercept=y_intersect-Bot_sec_slope*x_intersect;
Bot_Sec_line=@(y) (y-Bot_sec_intercept)/Bot_sec_slope;
j=0;

while x_bot_c<x_intersect
    x_bot_b=x_bot_a;
    y_bot_b=y_eq(x_bot_b);
    plot([x_bot_a x_bot_b],[y_bot_a y_bot_b],'-b')
    y_bot_c=y_bot_b;
    x_bot_c=Bot_Sec_line(y_bot_b);
    plot([x_bot_b x_bot_c],[y_bot_b y_bot_c],'-b')
    y_bot_stage_calc=y_bot_a;
    x_bot_a=x_bot_c;
    y_bot_a=y_bot_c;
    j=j+1;
end

NTS_BOT=j-(y_bot_c-y_intersect)/(y_bot_c-y_bot_stage_calc);
fprintf('\nThe number of top section theoretical stages is %2.2f',NTS_TOP)
fprintf('\nThe number of bottom section theoretical stages is %2.2f',NTS_BOT)
fprintf('\nThe number of top section actual stages is %2.0f',ceil(NTS_TOP/Effeciency))
fprintf('\nThe number of bottom section actual stages is %2.0f\n',ceil(NTS_BOT/Effeciency))
