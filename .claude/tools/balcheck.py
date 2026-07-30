import sys
for path in sys.argv[1:]:
    src=open(path).read()
    i=0;n=len(src);stack=[];pairs={')':'(',']':'[','}':'{'};err=[]
    def scan(i,endch=None):
        while i<n:
            c=src[i]
            if c=='/' and i+1<n and src[i+1]=='/':
                while i<n and src[i]!='\n': i+=1
                continue
            if c=='/' and i+1<n and src[i+1]=='*':
                i+=2
                while i<n-1 and not(src[i]=='*' and src[i+1]=='/'): i+=1
                i+=2; continue
            if c in "'\"": i=scan_str(i); continue
            if endch and c==endch: return i
            if c in '([{': stack.append((c,i)); i+=1; continue
            if c in ')]}':
                if not stack or stack[-1][0]!=pairs[c]: err.append((c,src.count(chr(10),0,i)+1))
                else: stack.pop()
                i+=1; continue
            i+=1
        return i
    def scan_str(i):
        q=src[i];triple=src[i:i+3]==q*3
        i+= 3 if triple else 1
        while i<n:
            c=src[i]
            if c=='\\': i+=2; continue
            if not triple and c==q: return i+1
            if triple and src[i:i+3]==q*3: return i+3
            if c=='$' and i+1<n and src[i+1]=='{':
                i+=2; i=scan(i,'}')
                if i<n and src[i]=='}': i+=1
                continue
            i+=1
        return i
    scan(0)
    base=path.split('/')[-1]
    print(f"{base}: {'BALANCED' if not stack and not err else 'PROBLEM leftover='+str([(c,src.count(chr(10),0,idx)+1) for c,idx in stack])+' err='+str(err[:3])}")
