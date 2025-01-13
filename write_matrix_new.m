function funval=write_matrix_new(A, filename, s, y, outtype)

fp = fopen(filename, s);
[rsize csize] = size(A);
ctext = [];
for i=1:csize 
    if (i == csize)
        if (outtype == 'exp')
            ctext = [ctext '%15.8e\n'];
        elseif (outtype == 'dec')
            ctext = [ctext '%15.8d\n'];
        else
            ctext = [ctext '%15.8f\n'];
        end;
    else
        if (outtype == 'exp')
            ctext = [ctext ['%15.8e' y]];
        elseif (outtype == 'dec')
            ctext = [ctext ['%15.8d' y]];
        else
            ctext = [ctext ['%15.8f' y]];
        end;
    end;
end;
fprintf(fp, ctext, A');
fclose(fp);