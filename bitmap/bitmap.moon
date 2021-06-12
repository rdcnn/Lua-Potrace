has_ffi, ffi = pcall(-> require "ffi")

if has_ffi
	ffi.cdef [[
		typedef struct color {
			uint8_t r, g, b;
		} color;
	]]

read_word = (data, offset) -> data\byte(offset + 1) * 256 + data\byte(offset)
read_dword = (data, offset) -> read_word(data, offset + 2) * 65536 + read_word(data, offset)

local bitmap
bitmap = {
	decode_from_string: (data) ->
		if not (read_dword(data, 1) == 0x4D42) -- Bitmap "magic" header
			return nil, "Bitmap magic not found"
		elseif (read_word(data, 29) != 24) -- Bits per pixel
			return nil, "Only 24bpp bitmaps supported"
		elseif (read_dword(data, 31) != 0) -- Compression
			return nil, "Only uncompressed bitmaps supported"

		bmp = {
			:data,
			pixel_offset: read_word(data, 11),
			w: read_dword(data, 19),
			h: read_dword(data, 23)
		} -- We'll return this to the user

		bmp.get_pixel = (self, x, y) ->
			if (x < 0) or (x > @w) or (y < 0) or (y > @h)
				return nil, "Out of bounds"
			index = @pixel_offset + (@h - y - 1) * 3 * @w + x * 3
			b = @data\byte(index + 1)
			g = @data\byte(index + 2)
			r = @data\byte(index + 3)
			return r, g, b

		bmp.map = (self) ->
			bit, i = has_ffi and ffi.new("color[?]", @w * @h) or {}, 0
			for y = 0, @h - 1
				for x = 0, @w - 1
					r, g, b = @get_pixel(x, y)
					if has_ffi
						bit[i].r = r
						bit[i].g = g
						bit[i].b = b
					else
						bit[i] = {r: r, g: g, b: b}
					i += 1
			return bit

		bmp.write_to_file = (self, path) ->
			file = assert(io.open(path, "wb"), "Can't open file")
			file\write(bmp.data)
			file\close!
			return #bmp.data
		return bmp

	decode_from_file: (path) ->
		file = assert(io.open(path, "rb"), "Can't open file!")
		content = file\read("*a")
		file\close!
		return bitmap.decode_from_string(content)
}

return {:bitmap}