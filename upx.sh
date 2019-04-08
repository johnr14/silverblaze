

# Compress elf binary
find . -executable -type f -print0 | xargs -0 file |\
grep ELF | cut -d: -f1 |\
while read f 
do
   upx --best --ultra-brute "$f"
done


