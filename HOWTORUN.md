# How To Run The Solution

Use the script `process.sh` to generate **questions** and **answers** files in the directory of the argument input.

For example, for the example file `spec/data/words`, one would run
```azure
./process.sh spec/data/words
```
which will output files
```azure
spec/data/questions
spec/data/answers
```

When running the script, one should see feedback
```% ./process.sh spec/data/words
argument:spec/data/words
6 words written to questions file
6 words written to answers file
```

When running against the reference file `words.tar.gz`
```azure
% ./process.sh words.tar.gz   
argument:words.tar.gz
10078 words written to questions file
10078 words written to answers file
```

Currently, numbers, apostrophe (') and period (.) characters are filtered out before calculating the length of the word.
