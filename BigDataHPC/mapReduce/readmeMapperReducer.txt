### connie sosa: 2/27/2016
### DS730: Project 3
### 3 mappers and 3 reducers python code, and sort.py runs after each mapper and before each reducer
### like the following :

echo "Running Problem 1 ..."
python mapperProb1.py < input1.txt | python sort.py | python reducerProb1.py > oupoutProb1.txt

echo "Running Problem 2 ..."
python mapperProb2.py < input2.txt | python sort.py | python reducerProb2.py > oupoutProb2.txt

echo "Running Problem 3 ..."
python mapperProb3.py < input3.txt | python sort.py | python reducerProb3.py > oupoutProb3.txt
