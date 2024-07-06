# sendCv.py - CV Sender

## Introduction

`sendCv.py` is a Python script designed to facilitate sending job application emails with a CV attachment. It allows users to specify recipient email addresses, email subjects, and CV attachments directly from the command line.

##GIF

![banner.gif](./banner.gif)

## Why Use `sendCv.py`?

- **Simplicity:** Easily send personalized job application emails with just a few command-line arguments.
- **Flexibility:** Specify recipient email, subject, and CV attachment path dynamically.
- **Automation:** Integrate into scripts or automated workflows for repetitive tasks.

## How to Set Up

### Prerequisites

- Python 3 installed on your system.
- `pip` installed to manage Python packages.
- Gmail account (or another SMTP-enabled email provider) for sending emails.

### Installation Steps

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/durge5h/DailyTasksAutomation.git
   cd DailyTasksAutomation/sendCv
   ```

2. **Install Required Packages:**
   ```sh
   pip install -r requirements.txt
   ```

3. **Set Up Environment Variables:**

   - Create a `.env` file in the project directory with your email credentials:
     ```sh
     echo "EMAIL=your_email@gmail.com" > .env
     echo "EMAIL_PASSWORD=your_email_password" >> .env
     ```
     Replace `your_email@gmail.com` with your Gmail address and `your_email_password` with your Gmail password or an application-specific password if using 2-factor authentication.

4. **Make the Script Executable:**
   ```sh
   chmod +x sendCv.py
   ```

5. **Create a Symbolic Link (Optional):**
   If you want to run the script without specifying `.py` extension:
   ```sh
   ln -s /path/to/your/sendCv.py /usr/local/bin/sendCv
   ```
   
### Usage

#### Command-Line

##### Switches:

- **`-r`, `--recipient_email`** (required)
  - The recipient's email address.
  - Example: `-r hr@example.com`

- **`-s`, `--subject`** (optional)
  - The subject of the email. If not provided, the default subject "Job Application for [Position]" is used.
  - Example: `-s "Application for Senior Security Engineer"`

- **`-a`, `--attachment`** (optional)
  - The path to your CV file. If not provided, it defaults to the path based on the job position.
  - Example: `-a /path/to/your/CV.pdf`

- **`-p`, `--position`** (optional)
  - The job position you are applying for. If not provided, it defaults to "Pentester".
  - Example: `-p "Security Engineer"`

#### Example Commands:

1. **Send CV with all specified parameters:**
   ```sh
   python sendCv.py -r hr@example.com -s "Job Application for Pentester" -a "/path/to/CV.pdf" -p "Pentester"
   ```

2. **Send CV with default subject and attachment based on position:**
   ```sh
   python sendCv.py -r hr@example.com -p "Security Engineer"
   ```

3. **Send CV with only recipient email, using all defaults:**
   ```sh
   python sendCv.py -r hr@example.com
   ```

#### Ulauncher

![ulauncher1.png](./ulauncher.png)

## Using Google App Passwords

For enhanced security, it's recommended to use Google app passwords instead of your main Google account password when using `sendCv.py`. Follow these steps to generate an app password:

1. **Generate Google App Password:**

   - Go to your Google Account settings and navigate to **Security**.
   - Under **Signing in to Google**, select **App passwords** (you may need to enable 2-step verification if not already enabled).
   - Generate a new app password for `sendCv.py` with the scope set to **Mail**.
   - Use this generated app password in your `.env` file instead of your main Google account password.

## Security Concerns

### Secure Handling of Email Credentials


By leveraging HashiCorp Vault or a similar secure vault solution, you can significantly enhance the security of your Python script (`sendCv.py`) by centralizing and securing credential management. This approach mitigates the risks associated with storing credentials in environment variables and ensures compliance with security best practices.

---

