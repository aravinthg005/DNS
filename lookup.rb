def get_command_line_argument
    # ARGV is an array that Ruby defines for us,
    # which contains all the arguments we passed to it
    # when invoking the script from the command line.
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end
  
  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument
  
  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  
  
  def parse_dns(dns_raw)

    a = {}
    cname = {}

    dns_raw.each { |rec| 

                        record = rec.split(', ')

                        if record[0].strip == 'A'
                            key = record[1].strip
                            a[key] = record[2].strip

                        elsif record[0].strip == 'CNAME'
                            key = record[1].strip
                            cname[key] = record[2].strip

                        end

                }

    dns_records = { 
                    :a => a,
                    :cname =>cname,
                }
    
    dns_records

  end

  def resolve(dns_records,lookup_chain,domain)

    if dns_records[:cname].key?(domain)
        lookup_chain.push(dns_records[:cname][domain])
        resolve(dns_records,lookup_chain,dns_records[:cname][domain])
    
    elsif dns_records[:a].key?domain
        lookup_chain.push(dns_records[:a][domain])
        return lookup_chain
        
    else
        lookup_chain.clear
        puts "Error - Invalid domain name"
        exit
    end

  end
    
 
  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")