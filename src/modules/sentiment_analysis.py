# conduct sentinment analysis on financial text
from transformers import BertTokenizer, BertForSequenceClassification
from transformers import pipeline

finbert = BertForSequenceClassification.from_pretrained(pretrained_model_name_or_path='ProsusAI/finbert')
tokenizer = BertTokenizer.from_pretrained(pretrained_model_name_or_path='ProsusAI/finbert')
nlp = pipeline(task="sentiment-analysis", model=finbert, tokenizer=tokenizer)

def analyze_sentiment(text: str):
    return nlp(text)
