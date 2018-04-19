# brew install tesseract
# curl -L -o /usr/local/share/tessdata/jpn.traineddata 'https://github.com/tesseract-ocr/tessdata/raw/3.04.00/jpn.traineddata'
tesseract -psm 6 test.jpg stdout -l eng+jpn
