stream = [0 64 255];

cntm1 = 0;

L = length(stream);
q_m_stream = zeros(L,9);
q_stream = zeros(L,10);

for k = 1:L

col = stream(k)

D = zeros(1,8);

for i = 1:8
	D(i) = 2^(8-i) <= col;
	col = col - D(i) * 2^(8-i);
end

D = D(8:-1:1)

DE = 1;
C0 = 0;
C1 = 0;

cnt = 0;

q_m = zeros(1,9);
q_out = zeros(1,10);

C = [C0 C1];

Nb1s = sum(D);

q_m(1) = D(1);
if Nb1s > 4 || Nb1s == 4 && D(1) == 0
	for i = 1:7
		q_m(i+1) = ~xor(q_m(i),D(i+1));
	end
	q_m(9) = 0;
else
	for i = 1:7
		q_m(i+1) = xor(q_m(i),D(i+1));
	end
	q_m(9) = 1;
end

if DE == 1
	if cntm1 == 0 || sum(q_m(1:8)) == sum(~q_m(1:8))
		q_out(10) = q_m(9);
		q_out(9) = q_m(9);
		if q_m(9) == 1
			q_out(1:8) = q_m(1:8);
		else
			q_out(1:8) = ~q_m(1:8);
		end
		if q_m(9) == 0
			cntm1 = cntm1 + sum(~q_m(1:8)) - sum(q_m(1:8));
		else
			cntm1 = cntm1 + sum(q_m(1:8)) - sum(~q_m(1:8));
		end
	else
		if cntm1 > 0 && sum(q_m(1:8)) > sum(~q_m(1:8)) || cntm1 < 0 && sum(~q_m(1:8)) > sum(q_m(1:8))
			q_out(10) = 1;
			q_out(9) = q_m(9);
			q_out(1:8) = ~q_m(1:8);
			cntm1 = cntm1 + 2*q_m(9) + sum(~q_m(1:8)) - sum(q_m(1:8));
		else
			q_out(10) = 0;
			q_out(9) = q_m(9);
			q_out(1:8) = q_m(1:8);
			cntm1 = cntm1 - 2*q_m(9) + sum(q_m(1:8)) - sum(~q_m(1:8));
		end
	end
else
%DE == 0
	switch C
		case [0 0]
			q_out = [0 0 1 0 1 0 1 0 1 1];
		case [0 1]
			q_out = [0 0 1 0 1 0 1 0 1 0];
		case [1 0]
			q_out = [1 1 0 1 0 1 0 1 0 0];
		case [1 1]
			q_out = [1 1 0 1 0 1 0 1 0 1];
	end
end

q_m
q_out	
cntm1

q_m_stream(k,:) = q_m;
q_stream(k,1:10) = q_out;

end

q_m_stream
q_stream
