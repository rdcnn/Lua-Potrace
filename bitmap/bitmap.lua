local has_ffi, ffi = pcall(function() return require "ffi" end)

if has_ffi then
	ffi.cdef [[
		typedef struct color {
			uint8_t r, g, b;
		} color;
	]]
end

local function read_word(data, offset)
	return data:byte(offset + 1) * 256 + data:byte(offset)
end

local function read_dword(data, offset)
	return read_word(data, offset + 2) * 65536 + read_word(data, offset)
end

local bitmap
bitmap = {
	decode_from_string = function(data)
		if not read_dword(data, 1) == 0x4D42 then -- Bitmap "magic" header
			return nil, "Bitmap magic not found"
		elseif read_word(data, 29) ~= 24 then -- Bits per pixel
			return nil, "Only 24bpp bitmaps supported"
		elseif read_dword(data, 31) ~= 0 then -- Compression
			return nil, "Only uncompressed bitmaps supported"
		end

		local bmp = {
			data = data,
			pixel_offset = read_word(data, 11),
			w = read_dword(data, 19),
			h = read_dword(data, 23)
		} -- We'll return this to the user

		function bmp:get_pixel(x, y)
			if (x < 0) or (x > self.w) or (y < 0) or (y > self.h) then
				return nil, "Out of bounds"
			end
			local index = self.pixel_offset + (self.h - y - 1) * 3 * self.w + x * 3
			local b = self.data:byte(index + 1)
			local g = self.data:byte(index + 2)
			local r = self.data:byte(index + 3)
			return r, g, b
		end

		function bmp:map()
			local bit, i = has_ffi and ffi.new("color[?]", self.w * self.h) or {}, 0
			for y = 0, self.h - 1 do
				for x = 0, self.w - 1 do
					local r, g, b = self:get_pixel(x, y)
					if has_ffi then
						bit[i].r = r
						bit[i].g = g
						bit[i].b = b
					else
						bit[i] = {r = r, g = g, b = b}
					end
					i = i + 1
				end
			end
			return bit
		end

		function bmp:write_to_file(path)
			local file = io.open(path, "wb")
			if not file then
				return nil, "Can't open file"
			end
			file:write(bmp.data)
			file:close()
			return #bmp.data
		end
		return bmp
	end,

	decode_from_file = function(path)
		local file = assert(io.open(path, "rb"), "Can't open file!")
		local content = file:read("*a")
		file:close()
		return bitmap.decode_from_string(content)
	end
}

return {
	bitmap = bitmap
}