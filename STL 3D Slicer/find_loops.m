function loops = find_loops(edgec)

    e2 = edgec;
    n = height(e2);
    i=1; %Loop Index

    while(n>0)
        first = e2(1,:);
        loop=[first(1) first(2)];
        e2(1,:)=[];
        n = height(e2);
        a=loop(end);
        while(a~=loop(1))
           pos = find(e2 == loop(end));
           if length(pos)==1
               if pos>n
                   loop(end+1)=e2(pos-n);
                   del=pos-n;
               elseif pos<=n
                   loop(end+1)=e2(pos+n);
                   del=pos;
               end
               e2(del,:)=[];
               n=height(e2);
               a=loop(end);               
           end
        end
        loops{i}=loop;
        i=i+1;
        n=height(e2);

end