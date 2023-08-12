# Create a flat CSV file with random data for use in the Jupyter notebook

import csv
import random
from faker import Faker
from datetime import datetime, timedelta

# Create a Faker instance
fake = Faker()

# Define possible subscription types
subscription_types = ['free', 'enterprise', 'self-serve']

# Define possible conversation types
conversation_types = ['sales inquiry', 'technical support', 'customer service']

# Generate random data and write to CSV
num_rows = 200  # Number of rows you want in the CSV

with open('conversation_data.csv', 'w', newline='') as csvfile:
    fieldnames = ['conversation_id', 'conversation_type', 'user_id', 'user_email', 'usage_frequency', 'support_agent_id',
                  'started_at', 'closed_at', 'company_id', 'company_name',
                  'subscription_id', 'subscription_type', 'score_id',
                  'created_at', 'score']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    for _ in range(num_rows):
        started_at = fake.date_time_this_year()
        closed_at = started_at + timedelta(hours=random.randint(1, 72))

        writer.writerow({
            'conversation_id': fake.uuid4(),
            'conversation_type': random.choice(conversation_types),
            'user_id': fake.random_int(min=1, max=1000),
            'user_email': fake.email(),
            'usage_frequency': fake.random_int(min=1, max=100),
            'support_agent_id': fake.random_int(min=1000, max=2000),
            'started_at': started_at.strftime('%Y-%m-%d %H:%M:%S'),
            'closed_at': closed_at.strftime('%Y-%m-%d %H:%M:%S'),
            'company_id': fake.random_int(min=1, max=50),
            'company_name': fake.company(),
            'subscription_id': fake.uuid4(),
            'subscription_type': random.choice(subscription_types),
            'score_id': fake.uuid4(),
            'created_at': started_at.strftime('%Y-%m-%d %H:%M:%S'),
            'score': fake.random_int(min=1, max=5),
        })

print("CSV data generated successfully.")
