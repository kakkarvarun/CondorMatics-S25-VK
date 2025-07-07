#!/bin/bash

# Install Nginx with a delay for package manager stability
sudo amazon-linux-extras install -y nginx1
sleep 3  # Allow time for installation to complete

# Start Nginx with verification
sudo service nginx start
sleep 2  # Give Nginx time to fully initialize

# Download files from S3 with staggered delays
aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/index.html /home/ec2-user/index.html
sleep 1  # Prevent S3 rate limiting

aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/style.css /home/ec2-user/styles.css
sleep 1

aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/campus.jpg /home/ec2-user/campus.jpg
sleep 1

aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/students.jpg /home/ec2-user/students.jpg 
sleep 1

aws s3 cp s3://${aws_s3_bucket.web_bucket.id}/webcontent/programs.jpg /home/ec2-user/programs.jpg
sleep 2  # Extra delay after large files

# Configure Nginx with verification steps
# sudo rm /usr/share/nginx/html/index.html
sleep 0.5  # Allow filesystem operations to complete

# Create temporary index.html
#echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
sleep 0.5

# Copy all files with delays between operations
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sleep 0.3

sudo cp /home/ec2-user/styles.css /usr/share/nginx/html/styles.css
sleep 0.3

sudo cp /home/ec2-user/campus.jpg /usr/share/nginx/html/campus.jpg
sleep 0.5  # Larger delay for media files

sudo cp /home/ec2-user/students.jpg /usr/share/nginx/html/students.jpg
sleep 0.5

sudo cp /home/ec2-user/programs.jpg /usr/share/nginx/html/programs.jpg

# Final verification
sleep 2  # Allow all copy operations to complete
sudo service nginx restart  # Ensure new configuration is loaded