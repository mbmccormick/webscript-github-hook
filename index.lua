-- extract credentials from query string
local email = request.query.email
local key = request.query.key

-- parse post-receive hook payload
local data = json.parse(request.form.payload)

-- extract repository name and url
local repository = data.repository.name
local repositoryUrl = data.repository.url

-- initialize changelist arrays
local added = {}
local modified = {}
local removed = {}

-- extract changelist from each commit
for key1, value1 in pairs(data.commits) do
  local commit = value1
	
	-- store list of files to be added
	for key2, value2 in pairs(commit.added) do
		table.insert(added, value2)
	end
	
	-- store list of files to be mofified
	for key2, value2 in pairs(commit.modified) do
		table.insert(modified, value2)
	end
	
	-- store list of files to be removed
	for key2, value2 in pairs(commit.removed) do
		table.insert(removed, value2)
	end
end

-- loop through files to be added
for i = 1, # added do
	-- fetch script from github repository
	local response1 = http.request {
		url = repositoryUrl .. '/raw/master/' .. added[i]
	}
	
	local script = response1.content
	
	local file = added[i]:gsub('.lua', '')
	
	-- create script on webscript servers
	local response2 = http.request {
		url = 'https://www.webscript.io/api/0.1/script/' .. repository .. '/' .. file,
		method = 'POST',
		auth = {
			email,
			key
		},
		data = script
	}
end

-- loop through files to be modified
for i = 1, # modified do
	-- fetch script from github repository
	local response1 = http.request {
		url = repositoryUrl .. '/raw/master/' .. modified[i]
	}
	
	local script = response1.content
	
	local file = modified[i]:gsub('.lua', '')
	
	-- update script on webscript servers
	local response2 = http.request {
		url = 'https://www.webscript.io/api/0.1/script/' .. repository .. '/' .. file,
		method = 'POST',
		auth = {
			email,
			key
		},
		data = script
	}
end

-- loop through files to be removed
for i = 1, # removed do
	local file = removed[i]:gsub('.lua', '')
	
	-- delete script from webscript servers
	local response2 = http.request {
		url = 'https://www.webscript.io/api/0.1/script/' .. repository .. '/' .. file,
		method = 'DELETE',
		auth = {
			email,
			key
		}
	}
end
