function h = DLT(p1,p2)
if (size(p1,1) ~= 3)
    p1 = padarray(p1,[1 0],1,'post');
    p2 = padarray(p2,[1 0],1,'post');
end
x2 = p2(1,:);
y2 = p2(2,:);
z2 = p2(3,:);
% Ah = 0
a = [];
for i=1:size(p1,2)
    a = [a; zeros(3,1)'     -z2(i)*p1(:,i)'   y2(i)*p1(:,i)'; ...
            z2(i)*p1(:,i)'   zeros(3,1)'     -x2(i)*p1(:,i)'];
end
% Obtain the SVD of A. The unit singular vector corresponding to the
% smallest singular value is the solucion h. A = UDV' with D diagonal with
% positive entries, arranged in descending order down the diagonal, then h
% is the last column of V.
[u,d,v] = svd(a);
h = reshape(v(:,9),3,3)';
end