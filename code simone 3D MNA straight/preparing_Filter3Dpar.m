function [H,Hs,center_node_coordinate]=preparing_Filter3Dpar(FEM_structure,rmin)
%% Preparing Filter
x1=FEM_structure.x1;
y1=FEM_structure.y1;
z1=FEM_structure.z1;
x2=FEM_structure.x2;
y2=FEM_structure.y2;
z2=FEM_structure.z2;
x3=FEM_structure.x3;
y3=FEM_structure.y3;
z3=FEM_structure.z3;
x4=FEM_structure.x4;
y4=FEM_structure.y4;
z4=FEM_structure.z4;
x5=FEM_structure.x5;
y5=FEM_structure.y5;
z5=FEM_structure.z5;
x6=FEM_structure.x6;
y6=FEM_structure.y6;
z6=FEM_structure.z6;
x7=FEM_structure.x7;
y7=FEM_structure.y7;
z7=FEM_structure.z7;
x8=FEM_structure.x8;
y8=FEM_structure.y8;
z8=FEM_structure.z8;
x1o=FEM_structure.x1o;
y1o=FEM_structure.y1o;
z1o=FEM_structure.z1o;
x2o=FEM_structure.x2o;
y2o=FEM_structure.y2o;
z2o=FEM_structure.z2o;
x3o=FEM_structure.x3o;
y3o=FEM_structure.y3o;
z3o=FEM_structure.z3o;
x4o=FEM_structure.x4o;
y4o=FEM_structure.y4o;
z4o=FEM_structure.z4o;
x5o=FEM_structure.x5o;
y5o=FEM_structure.y5o;
z5o=FEM_structure.z5o;
x6o=FEM_structure.x6o;
y6o=FEM_structure.y6o;
z6o=FEM_structure.z6o;
x7o=FEM_structure.x7o;
y7o=FEM_structure.y7o;
z7o=FEM_structure.z7o;
x8o=FEM_structure.x8o;
y8o=FEM_structure.y8o;
z8o=FEM_structure.z8o;
num_old_el=length(x1o);
num_new_el=length(x1);
nlin=num_new_el/num_old_el;
Element_id=1:num_new_el;
Projmat=(reshape(Element_id,nlin,[]));
center_node_coordinateo=[(x1o+x2o+x3o+x4o+x5o+x6o+x7o+x8o)/8,(y1o+y2o+y3o+y4o+y5o+y6o+y7o+y8o)/8,(z1o+z2o+z3o+z4o+z5o+z6o+z7o+z8o)/8];
center_node_coordinate=[(x1+x2+x3+x4+x5+x6+x7+x8)/8,(y1+y2+y3+y4+y5+y6+y7+y8)/8,(z1+z2+z3+z4+z5+z6+z7+z8)/8];
iHc=1:length(x1o);
jHc=1:length(x1o);
[IHc,JHc]=meshgrid((iHc),(jHc));
IHc=IHc(:);JHc=JHc(:);
ids=IHc>=JHc;
IHc=IHc(ids);JHc=JHc(ids);
SHc= max(zeros(size(JHc)),2*rmin*80-sqrt(sum((center_node_coordinateo(IHc,:)-center_node_coordinateo(JHc,:)).^2,2)));
non_zero_id=find(SHc);
IHc=IHc(non_zero_id);
JHc=JHc(non_zero_id);
iih=((zeros(size(Projmat,1)*(size(Projmat,1)),length(IHc))));
jjh=(iih);
% Ssc=iih;
parfor k=1:length(IHc)
    A=Projmat(:,IHc(k));
    B=Projmat(:,JHc(k));
    [IH,JH]=meshgrid((A),(B));
    IH=IH(:);JH=JH(:);
    iih(:,k)=IH;jjh(:,k)=JH;
end
iih=iih(:);
jjh=jjh(:);

% Ssc=Ssc(:);
ids=iih>=jjh;
iih=iih(ids);
jjh=jjh(ids);
Ssc= FEM_structure.A2(jjh).*max(zeros(size(iih)),rmin*80-sqrt(sum((center_node_coordinate(iih,:)-center_node_coordinate(jjh,:)).^2,2)));

% Ssc=Ssc(ids);
H=sparse(iih,jjh,Ssc,length(x1),length(x1));H=H-spdiags(FEM_structure.A2*rmin*80,0,length(x1),length(x1))+H.';
Hs = sum(H,2);