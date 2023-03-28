# voca

Memorize new words with spaced repetition

---
<p float="left">
  <img src="images/pic0.jpg" width="250" />
  <img src="images/pic1.jpg" width="250" /> 
</p>

---


## Features
- Search for a word, check its definition, and add it to the Learning list.
- Those words then show up on cards when you go to Practice. 
- Swipe the card if you remember the word, or tap See the Definition (flip the card) if you don't.
- If you remember the word, it will show up after a longer interval next time.
- If you don't, the progress is reset.
---
- If you come across a new word elsewhere, select the text and tap the three dots - you will be able
to add the word to the app in a quicker way.

## Project status
This is the most basic MVP, consider this Alpha access. It's already useable but lots of improvements & features are on the way. 
Bug reports & feature requests are welcome. When this gets a bit more mature I'll upload it to the stores. 

## Initialize project
```
flutter packages pub get
flutter pub run slang
flutter pub run build_runner build --delete-conflicting-outputs
```
Then pick a development or production configuration in vscode - some (unfinished) features are disabled in prod.

## Sources
Wordnet: https://wordnet.princeton.edu/

Words by frequency of use dataset: https://www.kaggle.com/datasets/wheelercode/dictionary-word-frequency?resource=download
