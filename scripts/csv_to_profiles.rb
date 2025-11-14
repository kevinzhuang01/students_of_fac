#!/usr/bin/env ruby

require 'csv'
require 'yaml'

# Helper script to convert CSV profile data to Jekyll profile pages

def slugify(text)
  text.to_s.downcase.strip.gsub(/[^a-z0-9\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
end

def slugify_faculty(name)
  name.to_s.downcase.strip.gsub(/[^a-z0-9\s-]/, '').gsub(/\s+/, '-').gsub(/-+/, '-')
end

def process_faculty(faculty_string)
  return [] if faculty_string.nil? || faculty_string.strip.empty?
  
  faculty_names = faculty_string.split(',').map(&:strip)
  faculty_names.map do |name|
    next if name.empty?
    slug = slugify_faculty(name)
    {
      'name' => name,
      'slug' => slug,
      'url' => "https://kevinzhuang01.github.io/faculty_2025/profiles/#{slug}/"
    }
  end.compact
end

def csv_to_profiles
  csv_file = '_data/profiles.csv'
  profiles_dir = '_profiles'
  
  unless File.exist?(csv_file)
    puts "Error: #{csv_file} not found!"
    return
  end
  
  # Create profiles directory if it doesn't exist
  Dir.mkdir(profiles_dir) unless Dir.exist?(profiles_dir)
  
  # Read CSV and create profile pages
  CSV.foreach(csv_file, headers: true) do |row|
    first_name = row['First/Given Names (first)']
    last_name = row['Last/Family Name (first)']
    name = "#{first_name}_#{last_name}"
    next if name.nil? || name.strip.empty?
    
    slug = slugify(name)
    filename = "#{profiles_dir}/#{slug}.md"
    
    # Prepare image path based on person's name
    # Replace spaces with underscores for filename
    clean_first = first_name.downcase.strip.gsub(/\s+/, '_')
    clean_last = last_name.downcase.strip.gsub(/\s+/, '_')
    image_filename = "#{clean_first}_#{clean_last}.jpg"
    
    # Only set image path if file exists
    image_file_path = "assets/students_fac_pictures/#{image_filename}"
    image_path = File.exist?(image_file_path) ? "/assets/students_fac_pictures/#{image_filename}" : nil
    
    # Process faculty
    faculty_array = process_faculty(row['Faculty'])
    
    # Prepare front matter
    front_matter = {
      'layout' => 'profile',
      'submission' => row['Submission'],
      'name' => "#{first_name} #{last_name}",
      'email' => row['Email (first)'],
      'institution' => row['Institution'],
      'department' => row['Department'],
      'pronouns' => row['Pronouns'],
      'biography' => row['Biography (Maximum 200 words)'],
      'image' => image_path,
      'linkedin' => row['Link to LinkedIn Profile'],
      'website' => row['Your web page url'],
      'status' => row['Status (This Stage)'],
      'academic_status' => row['Academic Status'],
      'year' => row['Year in program'],
      'research_areas' => row['Research Area/Department (check as many as appropriate)'],
      'major' => row['Major/Specialty'],
      'degrees' => row['Degrees Earned or in Progress (Degree/Field/Year)'],
      'coursework' => row['What courses or academic preparation have you completed to prepare for a summer internship experience (we recommend at least two science or computer science classes)?'],
      'has_published' => row['Have you published any research or worked on research/technical projects (not a requirement)?'],
      'publications' => row['Where has your research been published or where have you conducted research/technical projects? Please include a few references, if available.'],
      'research_interests' => row['Please describe your research/academic interests.'],
      'topical_areas' => row['Please select all the topical areas that apply to your field of study:'],
      'faculty' => faculty_array
    }
    
    # Remove empty fields
    front_matter.reject! { |k, v| v.nil? || (v.respond_to?(:strip) ? v.strip.empty? : v.empty?) }
    
    # Create the profile page content
    content = "---\n"
    content += front_matter.to_yaml.gsub(/^---\n/, '')
    content += "---\n"
    
    # Write the file
    File.write(filename, content)
    puts "Created: #{filename}"
  end
  
  puts "\nProfile pages generated successfully!"
  puts "Remember to add profile images to the assets/images/ directory."
end

def csv_to_yaml
  csv_file = '_data/profiles.csv'
  yaml_file = '_data/profiles.yml'
  
  unless File.exist?(csv_file)
    puts "Error: #{csv_file} not found!"
    return
  end
  
  profiles = []
  CSV.foreach(csv_file, headers: true) do |row|
    profile = {}
    row.headers.each do |header|
      value = row[header]
      profile[header] = value if value && !value.strip.empty?
    end
    profiles << profile unless profile.empty?
  end
  
  File.write(yaml_file, profiles.to_yaml)
  puts "Created: #{yaml_file}"
end

# Main execution
if ARGV.include?('--yaml-only')
  csv_to_yaml
else
  csv_to_profiles
  csv_to_yaml
end
