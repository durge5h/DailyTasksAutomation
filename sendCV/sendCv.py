#!/usr/bin/env python3

import smtplib
import os
import argparse
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
from dotenv import load_dotenv

def send_email(sender_email, sender_password, recipient_email, subject, body, attachment_path):
    # Set up the email server
    server = smtplib.SMTP('smtp.gmail.com', 587)  # Using Gmail SMTP server
    server.starttls()  # Upgrade the connection to a secure encrypted SSL/TLS connection
    server.login(sender_email, sender_password)  # Log in to the email account

    # Create the email
    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = recipient_email
    msg['Subject'] = subject

    # Attach the email body
    msg.attach(MIMEText(body, 'plain'))

    # Attach the CV file
    filename = os.path.basename(attachment_path)
    with open(attachment_path, 'rb') as attachment:
        part = MIMEBase('application', 'octet-stream')
        part.set_payload(attachment.read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', f'attachment; filename={filename}')
        msg.attach(part)

    # Send the email
    text = msg.as_string()
    server.sendmail(sender_email, recipient_email, text)
    
    # Close the server connection
    server.quit()

    print("Email sent successfully.")

def get_cv_path(job_role):
    base_dir = '/home/example1/Documents/Resume'
    default_job_role = 'Pentester'
    cv_name = 'Resume.pdf'
    
    # Determine the job role directory
    job_dir = job_role if job_role else default_job_role
    
    # Construct the path to the CV file
    cv_path = os.path.join(base_dir, job_dir, cv_name)
    
    return cv_path

def main():
    # Load environment variables from the specified .env file
    dotenv_path = os.path.expanduser('~/.env')
    load_dotenv(dotenv_path)
    
    # Set up command line argument parsing
    parser = argparse.ArgumentParser(description='Send your CV via email.')
    parser.add_argument('recipient_email', help='Recipient email address')
    parser.add_argument('-s', '--subject', default='Job Application for [Your Position]', help='Email subject')
    parser.add_argument('-a', '--attachment', help='Path to your CV file')
    parser.add_argument('-p', '--position', default='Pentester', help='Position role for the email subject')

    args = parser.parse_args()

    # Get environment variables for sender email and password
    sender_email = os.getenv('EMAIL')
    sender_password = os.getenv('EMAIL_PASSWORD')

    if not sender_email or not sender_password:
        print("Email or password environment variables not set.")
        return

    # Determine the attachment path
    attachment_path = args.attachment if args.attachment else get_cv_path(args.position)

    if not os.path.exists(attachment_path):
        print(f"Attachment path {attachment_path} does not exist.")
        return

    # Prepare the email subject and body
    subject = args.subject.replace('[Your Position]', args.position)
    body = 'Dear Hiring Manager,\n\nPlease find attached my CV for your consideration.\n\nBest regards,\n[Your Name]'

    # Send the email
    send_email(sender_email, sender_password, args.recipient_email, subject, body, attachment_path)

if __name__ == '__main__':
    main()
