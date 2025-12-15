# Brief
This is admitedly vibe coded. It loads a txt file with your IP or CIDR ranges, then creates a file in tmp while processing. When completed, a new file appears in the current directory with a formatted .nft elements list.

# Usage
First give it permissions.

```
chmod +x txt2nft.sh
```
Then execute on a list of text files
```
./txt2nft.sh set1.txt set2.txt set3.txt
```
