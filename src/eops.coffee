`#!/usr/bin/env iojs
`

program = require 'commander'
fs = require 'fs'
csv = require 'csv-parser'
crypto = require 'crypto'
md5 = require 'md5'
sha1 = require 'sha1'

in_array = (needle, haystack) ->
  for key in haystack
    if haystack[key] == needle
      return true
  return false

log_lib = () ->
  console.log ''
  console.log 'Most org/sites doing matching want to see samples to know you "did it right". You can send them the below.'
  console.log ''
  console.log "Here's the samples:"
  console.log ''

program
  .version('2.0.6')
  .usage('[options] <emails.csv>')
  .option('-c --compare <file>', 'hashed emails (already_hashed.csv)')
  .option('-e --case <alter>', 'whether to upper or lower case the email before hashing (upper, lower, as-is)', /^(upper|lower|as\-is)$/i, 'as-is')
  .option('-h --header <header>', 'header on column that you want to hash. Defaults to "email".', /^([a-zA-Z0-9]{1,})$/i, 'email')
  .option('-o --output <output>', 'file name (exists.csv)')
  .option('-r --hash <hash>', 'hash library (sha1, md5)', /^(sha|md5)$/i, 'md5')
  .option('-s --salt <salt>', 'salt string. leave empty to not use a salt')
  .option('-p --preset <preset>', 'Convenience preset for poitical services and publications (dailykos, demsdotcom, vindico, care2, upworthy)', /^(dailykos|demsdotcom|vindico|care2|upworthy)$/i)
  .parse(process.argv)

  # .description('
  #   <compare> Compare an un-hashed email file to a hashed email file and display common emails or save them to a file. You can then use that file as a suppression list.
  # ')
  # .on('--help', () ->
  #   console.log '  Examples:'
  #   console.log
  #   console.log '    $ deploy exec sequential'
  #   console.log '    $ deploy exec async'
  #   console.log
  # )

# if(program.rule)
# if(program.preset)
# console.log(program.options)

# if(program.output)

# switch cmd
#   when compare
#     # compare two files and display common emails or save them to a file
#     console.log('Compare')
#   when hash
#     console.log('Hash')

if !program.args[0]
  console.log 'No file input provided'
else if program.args[0] == 'demsdotcom' || program.args[0] == 'dailykos'
  if program.args[0] == 'demsdotcom'
    console.log 'Democrats.com Hashing'
  else if program.args[0] == 'dailykos'
    console.log 'Daily Kos Hashing'
  log_lib()
  console.log 'someone@someTHing.com'
  console.log 'someone@something.org'
  console.log 'someone@something.net'
  console.log ''
  console.log md5('someone@someTHing.com'.toUpperCase())
  console.log md5('someone@something.org'.toUpperCase())
  console.log md5('someone@something.net'.toUpperCase())
else if program.args[0] == 'google'
  console.log 'Google Hashing'
  log_lib()
  console.log 'someone@someTHing.com'
  console.log 'someone@something.org'
  console.log 'someone@something.net'
  console.log ''
  shasum = crypto.createHash('sha1256')
  shasum.update('someone@someTHing.com'.toLowerCase())
  console.log shasum.digest('hex')
  shasum = crypto.createHash('sha1256')
  shasum.update('someone@something.org'.toLowerCase())
  console.log shasum.digest('hex')
  shasum = crypto.createHash('sha1256')
  shasum.update('someone@something.net'.toLowerCase())
  console.log shasum.digest('hex')
else if program.args[0] == 'care2' && program.salt
  console.log 'Care2 Hashing'
  log_lib()
  console.log 'someone@someTHing.com'
  console.log 'someone@something.org'
  console.log 'someone@something.net'
  console.log ''
  console.log sha1(program.salt+'someone@something.com')
  console.log sha1(program.salt+'someone@something.org')
  console.log sha1(program.salt+'someone@something.net')
else if program.args[0] == 'care2' && !program.salt
  console.log 'If you want to do Care2 hashing, you must supply a salt string.'
  console.log ''
  console.log 'eops --preset care2 --salt 8zQgWkEKYH4VxHcHN3ecUiFEH emails.csv'
else if program.args[0] == 'vindico'
  console.log 'Vindico Hashing'
  log_lib()
  console.log 'someone@someTHing.com'
  console.log 'someone@something.org'
  console.log 'someone@something.net'
  console.log ''
  console.log md5('someone@something.com')
  console.log md5('someone@something.org')
  console.log md5('someone@something.net')
else if program.args[0] == 'upworthy'
  console.log 'Upworthy Hashing'
  log_lib()
  console.log 'someone@someTHing.com'
  console.log 'someone@something.org'
  console.log 'someone@something.net'
  console.log ''
  console.log md5('someone@something.com'.toLowerCase())
  console.log md5('someone@something.org'.toLowerCase())
  console.log md5('someone@something.net'.toLowerCase())
else
  if program.compare
    hashed_r = []
    fs.createReadStream program.compare
    .pipe csv()
    .on 'data', (hashed) ->
      hashed_r[hashed_r.length] = hashed[program.header]
    .on 'error', (err) ->
      console.log err
    .on 'end', () ->
      if program.output
        fs.unlinkSync(program.output)
      fs.createReadStream(program.args[0])
        .pipe csv()
        .on 'data', (unhashed) ->
          to_check = md5 unhashed[program.header].toUpperCase()
          for key in hashed_r
            if key == to_check
              if program.output
                fs.appendFileSync(program.output, unhashed[program.header].toLowerCase()+"\r\n")
              else
                console.log unhashed[program.header].toLowerCase()
        .on 'end', () ->
          process.exit 0
        .on 'error', (err) ->
          console.log err
  else
    if program.output
      fs.unlinkSync(program.output)
      fs.appendFileSync(program.output, 'email'+"\r\n")
    fs.createReadStream program.args[0]
    .pipe csv()
    .on 'data', (unhashed) ->
      if program.args[0] == 'demsdotcom' || program.args[0] == 'dailykos'
        program.hash = 'md5'
        program.alter = 'upper'
      else if program.args[0] == 'care2' && program.salt
        program.hash = 'sha1'
        program.alter = 'as-is'
        unhashed = program.salt + unhashed
      else if program.args[0] == 'care2' && !program.salt
        console.log 'If you want to do Care2 hashing, you must supply a salt string.'
        console.log ''
        console.log 'eops --preset care2 --salt 8zQgWkEKYH4VxHcHN3ecUiFEH emails.csv'
        process.exit 1
      else if program.args[0] == 'vindico'
        program.hash = 'md5'
        program.alter = 'as-is'
      else if program.args[0] == 'upworthy'
        program.hash = 'md5'
        program.alter = 'lower'
      
      switch program.alter
        when 'upper' then cased_email = unhashed[program.header].toUpperCase()
        when 'lower' then cased_email = unhashed[program.header].toLowerCase()
        when 'as-is' then cased_email = unhashed[program.header]
        else cased_email = unhashed[program.header]
      switch program.hash
        when 'md5' then hashed_email = md5 cased_email
        when 'sha1' then hashed_email = sha1 cased_email
        else hashed_email = md5 cased_email
      
      if program.output
        fs.appendFileSync(program.output, hashed_email+"\r\n")
      else
        console.log hashed_email
    .on 'end', () ->
      process.exit 0
    .on 'error', (err) ->
      console.log 'An error occurred:', err
