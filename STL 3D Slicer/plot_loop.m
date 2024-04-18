function plot_loop(tt, verts, n)

figure
hold on
for i=n
    loop=tt{i};
    x = verts(loop(:),1);
    y = verts(loop(:),2);
    plot(x,y);
end
hold off

end