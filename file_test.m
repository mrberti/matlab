t = {};
s = {};
t{1} = 1:1+eps*1000:10;
s{1} = exp(t{1});
s{2} = log(t{1});

X = [t{1};cell2mat(s')]';

filename = '../python/test.csv';

try
  file = fopen(filename, 'w');
  fwrite(file, "data a,data b\r\nblabal,,asd/asd");
  fwrite(file, "\r\npath,a/b/c,this is a path/this not\r\nmuhpath,blabla");
  fprintf(file,"\r\n,%g,%.10e,%f", X');
catch
  warning('Error during file write');
end

fclose(file);

type('test.csv');