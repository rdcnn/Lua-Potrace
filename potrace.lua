-- Copyright (C) 2001-2013 Peter Selinger.
-- A javascript port of Potrace (http://potrace.sourceforge.net).
-- Licensed under the GPL

-- Lua port of https://github.com/kilobtye/potrace

-- Usage: "Moonscript"
--     potrace = Potrace filename -- filename = "example.bmp"
--     potrace.info.turnpolicy = "minority"
--     potrace.info.turdsize = 2
--     potrace.info.optcurve = true
--     potrace.info.alphamax = 1
--     potrace.info.opttolerance = 0.2
--     potrace\process!
--     svg = potrace\getSVG!

-- Usage: "Lua"
--     local potrace = Potrace(filename) -- filename = "example.bmp"
--     potrace.info.turnpolicy = "minority"
--     potrace.info.turdsize = 2
--     potrace.info.optcurve = true
--     potrace.info.alphamax = 1
--     potrace.info.opttolerance = 0.2
--     potrace:process()
--     local svg = potrace:getSVG()

local bitmap
bitmap = require("bitmap.bitmap").bitmap
table.push_b0 = function(t, ...)
  local n = select("#", ...)
  for i = 1, n do
    local v = select(i, ...)
    if not t[0] and #t == 0 then
      t[0] = v
    else
      t[#t + 1] = v
    end
  end
  return ...
end
local Point
do
  local _class_0
  local _base_0 = {
    copy = function(self)
      return Point(self.x, self.y)
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y)
      if x == nil then
        x = 0
      end
      if y == nil then
        y = 0
      end
      self.x = x
      self.y = y
    end,
    __base = _base_0,
    __name = "Point"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Point = _class_0
end
local Bitmap
do
  local _class_0
  local _base_0 = {
    at = function(self, x, y)
      return (x >= 0 and x < self.w and y >= 0 and y < self.h) and (self.data[self.w * y + x] == 1)
    end,
    index = function(self, i)
      local point = Point()
      point.y = math.floor(i / self.w)
      point.x = i - point.y * self.w
      return point
    end,
    flip = function(self, x, y)
      if self:at(x, y) then
        self.data[self.w * y + x] = 0
      else
        self.data[self.w * y + x] = 1
      end
    end,
    copy = function(self)
      local bm = Bitmap(self.w, self.h)
      for i = 0, self.size - 1 do
        bm.data[i] = self.data[i]
      end
      return bm
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, w, h)
      self.w = w
      self.h = h
      self.size = w * h
      self.data = { }
    end,
    __base = _base_0,
    __name = "Bitmap"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Bitmap = _class_0
end
local Curve
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, n)
      self.n = n
      self.tag = { }
      self.c = { }
      self.alphaCurve = 0
      self.vertex = { }
      self.alpha = { }
      self.alpha0 = { }
      self.beta = { }
    end,
    __base = _base_0,
    __name = "Curve"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Curve = _class_0
end
local Path
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.area = 0
      self.len = 0
      self.curve = { }
      self.pt = { }
      self.minX = 100000
      self.minY = 100000
      self.maxX = -1
      self.maxY = -1
    end,
    __base = _base_0,
    __name = "Path"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Path = _class_0
end
local Sum
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, x, y, xy, x2, y2)
      self.x = x
      self.y = y
      self.xy = xy
      self.x2 = x2
      self.y2 = y2
    end,
    __base = _base_0,
    __name = "Sum"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Sum = _class_0
end
local Configs
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.turnpolicy = "minority"
      self.turdsize = 2
      self.optcurve = true
      self.alphamax = 1
      self.opttolerance = 0.2
    end,
    __base = _base_0,
    __name = "Configs"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Configs = _class_0
end
local Potrace
do
  local _class_0
  local _base_0 = {
    process = function(self)
      self:bmToPathlist()
      self:processPath()
    end,
    bmToPathlist = function(self)
      local currentPoint = Point()
      local bm1 = self.bm:copy()
      local findNext
      findNext = function(point)
        local i = bm1.w * point.y + point.x
        while (i < bm1.size and bm1.data[i] ~= 1) do
          i = i + 1
        end
        return i < bm1.size and bm1:index(i) or nil
      end
      local majority
      majority = function(x, y)
        for i = 2, 4 do
          local ct = 0
          for a = -i + 1, i - 1 do
            ct = ct + (bm1:at(x + a, y + i - 1) and 1 or -1)
            ct = ct + (bm1:at(x + i - 1, y + a - 1) and 1 or -1)
            ct = ct + (bm1:at(x + a - 1, y - i) and 1 or -1)
            ct = ct + (bm1:at(x - i, y + a) and 1 or -1)
          end
          if (ct > 0) then
            return 1
          elseif (ct < 0) then
            return 0
          end
        end
        return 0
      end
      local findPath
      findPath = function(point)
        local path, x, y, dirx, diry = Path(), point.x, point.y, 0, 1
        path.sign = self.bm:at(point.x, point.y) and "+" or "-"
        while true do
          table.push_b0(path.pt, Point(x, y))
          if (x > path.maxX) then
            path.maxX = x
          end
          if (x < path.minX) then
            path.minX = x
          end
          if (y > path.maxY) then
            path.maxY = y
          end
          if (y < path.minY) then
            path.minY = y
          end
          path.len = path.len + 1
          x = x + dirx
          y = y + diry
          path.area = path.area - (x * diry)
          if (x == point.x and y == point.y) then
            break
          end
          local l = bm1:at(x + (dirx + diry - 1) / 2, y + (diry - dirx - 1) / 2)
          local r = bm1:at(x + (dirx - diry - 1) / 2, y + (diry + dirx - 1) / 2)
          if r and not l then
            if (self.info.turnpolicy == "right" or (self.info.turnpolicy == "black" and path.sign == '+') or (self.info.turnpolicy == "white" and path.sign == '-') or (self.info.turnpolicy == "majority" and majority(x, y)) or (self.info.turnpolicy == "minority" and not majority(x, y))) then
              local tmp = dirx
              dirx = -diry
              diry = tmp
            else
              local tmp = dirx
              dirx = diry
              diry = -tmp
            end
          elseif r then
            local tmp = dirx
            dirx = -diry
            diry = tmp
          elseif not l then
            local tmp = dirx
            dirx = diry
            diry = -tmp
          end
        end
        return path
      end
      local xorPath
      xorPath = function(path)
        local y1, len = path.pt[0].y, path.len
        for i = 1, len - 1 do
          local x = path.pt[i].x
          local y = path.pt[i].y
          if (y ~= y1) then
            local minY = y1 < y and y1 or y
            local maxX = path.maxX
            for j = x, maxX - 1 do
              bm1:flip(j, minY)
            end
            y1 = y
          end
        end
      end
      while (function()
        currentPoint = findNext(currentPoint)
        return currentPoint
      end)() do
        local path = findPath(currentPoint)
        xorPath(path)
        if path.area > self.info.turdsize then
          table.push_b0(self.pathlist, path)
        end
      end
    end,
    processPath = function(self)
      local Quad
      do
        local _class_1
        local _base_1 = {
          at = function(self, x, y)
            return self.data[x * 3 + y]
          end
        }
        _base_1.__index = _base_1
        _class_1 = setmetatable({
          __init = function(self)
            self.data = {
              [0] = 0,
              0,
              0,
              0,
              0,
              0,
              0,
              0,
              0
            }
          end,
          __base = _base_1,
          __name = "Quad"
        }, {
          __index = _base_1,
          __call = function(cls, ...)
            local _self_0 = setmetatable({}, _base_1)
            cls.__init(_self_0, ...)
            return _self_0
          end
        })
        _base_1.__class = _class_1
        Quad = _class_1
      end
      local mod
      mod = function(a, n)
        return a >= n and a % n or a >= 0 and a or n - 1 - (-1 - a) % n
      end
      local xprod
      xprod = function(p1, p2)
        return p1.x * p2.y - p1.y * p2.x
      end
      local sign
      sign = function(i)
        return i > 0 and 1 or i < 0 and -1 or 0
      end
      local ddist
      ddist = function(p, q)
        return math.sqrt((p.x - q.x) * (p.x - q.x) + (p.y - q.y) * (p.y - q.y))
      end
      local cyclic
      cyclic = function(a, b, c)
        if (a <= c) then
          return a <= b and b < c
        else
          return a <= b or b < c
        end
      end
      local quadform
      quadform = function(Q, w)
        local sum, v = 0, {
          [0] = w.x,
          [1] = w.y,
          [2] = 1
        }
        for i = 0, 2 do
          for j = 0, 2 do
            sum = sum + (v[i] * Q:at(i, j) * v[j])
          end
        end
        return sum
      end
      local interval
      interval = function(lambda, a, b)
        local res = Point()
        res.x = a.x + lambda * (b.x - a.x)
        res.y = a.y + lambda * (b.y - a.y)
        return res
      end
      local dorth_infty
      dorth_infty = function(p0, p2)
        local r = Point()
        r.y = sign(p2.x - p0.x)
        r.x = -sign(p2.y - p0.y)
        return r
      end
      local ddenom
      ddenom = function(p0, p2)
        local r = dorth_infty(p0, p2)
        return r.y * (p2.x - p0.x) - r.x * (p2.y - p0.y)
      end
      local dpara
      dpara = function(p0, p1, p2)
        local x1 = p1.x - p0.x
        local y1 = p1.y - p0.y
        local x2 = p2.x - p0.x
        local y2 = p2.y - p0.y
        return x1 * y2 - x2 * y1
      end
      local cprod
      cprod = function(p0, p1, p2, p3)
        local x1 = p1.x - p0.x
        local y1 = p1.y - p0.y
        local x2 = p3.x - p2.x
        local y2 = p3.y - p2.y
        return x1 * y2 - x2 * y1
      end
      local iprod
      iprod = function(p0, p1, p2)
        local x1 = p1.x - p0.x
        local y1 = p1.y - p0.y
        local x2 = p2.x - p0.x
        local y2 = p2.y - p0.y
        return x1 * x2 + y1 * y2
      end
      local iprod1
      iprod1 = function(p0, p1, p2, p3)
        local x1 = p1.x - p0.x
        local y1 = p1.y - p0.y
        local x2 = p3.x - p2.x
        local y2 = p3.y - p2.y
        return x1 * x2 + y1 * y2
      end
      local bezier
      bezier = function(t, p0, p1, p2, p3)
        local s, res = 1 - t, Point()
        res.x = s * s * s * p0.x + 3 * (s * s * t) * p1.x + 3 * (t * t * s) * p2.x + t * t * t * p3.x
        res.y = s * s * s * p0.y + 3 * (s * s * t) * p1.y + 3 * (t * t * s) * p2.y + t * t * t * p3.y
        return res
      end
      local tangent
      tangent = function(p0, p1, p2, p3, q0, q1)
        local A = cprod(p0, p1, q0, q1)
        local B = cprod(p1, p2, q0, q1)
        local C = cprod(p2, p3, q0, q1)
        local a = A - 2 * B + C
        local b = -2 * A + 2 * B
        local c = A
        local d = b * b - 4 * a * c
        if (a == 0 or d < 0) then
          return -1
        end
        local s = math.sqrt(d)
        local r1 = (-b + s) / (2 * a)
        local r2 = (-b - s) / (2 * a)
        if (r1 >= 0 and r1 <= 1) then
          return r1
        elseif (r2 >= 0 and r2 <= 1) then
          return r2
        else
          return -1
        end
      end
      local calcSums
      calcSums = function(path)
        path.x0 = path.pt[0].x
        path.y0 = path.pt[0].y
        path.sums = { }
        local s = path.sums
        table.push_b0(s, Sum(0, 0, 0, 0, 0))
        for i = 0, path.len - 1 do
          local x = path.pt[i].x - path.x0
          local y = path.pt[i].y - path.y0
          table.push_b0(s, Sum(s[i].x + x, s[i].y + y, s[i].xy + x * y, s[i].x2 + x * x, s[i].y2 + y * y))
        end
      end
      local calcLon
      calcLon = function(path)
        local n, pt, pivk, nc, ct, foundk
        n, pt, pivk, nc, ct, path.lon, foundk = path.len, path.pt, { }, { }, { }, { }
        local constraint = {
          [0] = Point(),
          Point()
        }
        local cur, off, dk, k = Point(), Point(), Point(), 0
        for i = n - 1, 0, -1 do
          if (pt[i].x ~= pt[k].x and pt[i].y ~= pt[k].y) then
            k = i + 1
          end
          nc[i] = k
        end
        for i = n - 1, 0, -1 do
          ct[0], ct[1], ct[2], ct[3] = 0, 0, 0, 0
          local dir = (3 + 3 * (pt[mod(i + 1, n)].x - pt[i].x) + (pt[mod(i + 1, n)].y - pt[i].y)) / 2
          ct[dir] = ct[dir] + 1
          constraint[0].x = 0
          constraint[0].y = 0
          constraint[1].x = 0
          constraint[1].y = 0
          k = nc[i]
          local k1 = i
          while true do
            foundk = 0
            dir = (3 + 3 * sign(pt[k].x - pt[k1].x) + sign(pt[k].y - pt[k1].y)) / 2
            ct[dir] = ct[dir] + 1
            if ct[0] ~= 0 and ct[1] ~= 0 and ct[2] ~= 0 and ct[3] ~= 0 then
              pivk[i] = k1
              foundk = 1
              break
            end
            cur.x = pt[k].x - pt[i].x
            cur.y = pt[k].y - pt[i].y
            if (xprod(constraint[0], cur) < 0 or xprod(constraint[1], cur) > 0) then
              break
            end
            if (math.abs(cur.x) <= 1 and math.abs(cur.y) <= 1) then
              local _ = _
            else
              off.x = cur.x + ((cur.y >= 0 and (cur.y > 0 or cur.x < 0)) and 1 or -1)
              off.y = cur.y + ((cur.x <= 0 and (cur.x < 0 or cur.y < 0)) and 1 or -1)
              if (xprod(constraint[0], off) >= 0) then
                constraint[0].x = off.x
                constraint[0].y = off.y
              end
              off.x = cur.x + ((cur.y <= 0 and (cur.y < 0 or cur.x < 0)) and 1 or -1)
              off.y = cur.y + ((cur.x >= 0 and (cur.x > 0 or cur.y < 0)) and 1 or -1)
              if (xprod(constraint[1], off) <= 0) then
                constraint[1].x = off.x
                constraint[1].y = off.y
              end
            end
            k1 = k
            k = nc[k1]
            if not cyclic(k, i, k1) then
              break
            end
          end
          if (foundk == 0) then
            dk.x = sign(pt[k].x - pt[k1].x)
            dk.y = sign(pt[k].y - pt[k1].y)
            cur.x = pt[k1].x - pt[i].x
            cur.y = pt[k1].y - pt[i].y
            local a = xprod(constraint[0], cur)
            local b = xprod(constraint[0], dk)
            local c = xprod(constraint[1], cur)
            local d = xprod(constraint[1], dk)
            local j = 10000000
            if (b < 0) then
              j = math.floor(a / -b)
            end
            if (d > 0) then
              j = math.min(j, math.floor(-c / d))
            end
            pivk[i] = mod(k1 + j, n)
          end
        end
        local j = pivk[n - 1]
        path.lon[n - 1] = j
        for i = n - 2, 0, -1 do
          if cyclic(i + 1, pivk[i], j) then
            j = pivk[i]
          end
          path.lon[i] = j
        end
        local i = n - 1
        while cyclic(mod(i + 1, n), j, path.lon[i]) do
          path.lon[i] = j
          i = i - 1
        end
      end
      local bestPolygon
      bestPolygon = function(path)
        local penalty3
        penalty3 = function(path, i, j)
          local x, y, xy, x2, y2, k
          local n, pt, sums, r = path.len, path.pt, path.sums, 0
          if (j >= n) then
            j = j - n
            r = 1
          end
          if (r == 0) then
            x = sums[j + 1].x - sums[i].x
            y = sums[j + 1].y - sums[i].y
            x2 = sums[j + 1].x2 - sums[i].x2
            xy = sums[j + 1].xy - sums[i].xy
            y2 = sums[j + 1].y2 - sums[i].y2
            k = j + 1 - i
          else
            x = sums[j + 1].x - sums[i].x + sums[n].x
            y = sums[j + 1].y - sums[i].y + sums[n].y
            x2 = sums[j + 1].x2 - sums[i].x2 + sums[n].x2
            xy = sums[j + 1].xy - sums[i].xy + sums[n].xy
            y2 = sums[j + 1].y2 - sums[i].y2 + sums[n].y2
            k = j + 1 - i + n
          end
          local px = (pt[i].x + pt[j].x) / 2 - pt[0].x
          local py = (pt[i].y + pt[j].y) / 2 - pt[0].y
          local ey = (pt[j].x - pt[i].x)
          local ex = -(pt[j].y - pt[i].y)
          local a = ((x2 - 2 * x * px) / k + px * px)
          local b = ((xy - x * py - y * px) / k + px * py)
          local c = ((y2 - 2 * y * py) / k + py * py)
          local s = ex * ex * a + 2 * ex * ey * b + ey * ey * c
          return math.sqrt(s)
        end
        local n = path.len
        local pen, prev, clip0, clip1, seg0, seg1 = { }, { }, { }, { }, { }, { }
        for i = 0, n - 1 do
          local c = mod(path.lon[mod(i - 1, n)] - 1, n)
          if (c == i) then
            c = mod(i + 1, n)
          end
          if (c < i) then
            clip0[i] = n
          else
            clip0[i] = c
          end
        end
        local j = 1
        for i = 0, n - 1 do
          while (j <= clip0[i]) do
            clip1[j] = i
            j = j + 1
          end
        end
        local i
        i, j = 0, 0
        while i < n do
          seg0[j] = i
          i = clip0[i]
          j = j + 1
        end
        seg0[j] = n
        local m = j
        i, j = n, m
        while j > 0 do
          seg1[j] = i
          i = clip1[i]
          j = j - 1
        end
        seg1[0] = 0
        pen[0] = 0
        j = 1
        while j <= m do
          for i = seg1[j], seg0[j] do
            local best = -1
            for k = seg0[j - 1], clip1[i], -1 do
              local thispen = penalty3(path, k, i) + pen[k]
              if (best < 0 or thispen < best) then
                prev[i] = k
                best = thispen
              end
            end
            pen[i] = best
          end
          j = j + 1
        end
        path.m = m
        path.po = { }
        i, j = n, m - 1
        while i > 0 do
          i = prev[i]
          path.po[j] = i
          j = j - 1
        end
      end
      local adjustVertices
      adjustVertices = function(path)
        local pointslope
        pointslope = function(path, i, j, ctr, dir)
          local n, sums, r = path.len, path.sums, 0
          while (j >= n) do
            j = j - n
            r = r + 1
          end
          while (i >= n) do
            i = i - n
            r = r - 1
          end
          while (j < 0) do
            j = j + n
            r = r - 1
          end
          while (i < 0) do
            i = i + n
            r = r + 1
          end
          local x = sums[j + 1].x - sums[i].x + r * sums[n].x
          local y = sums[j + 1].y - sums[i].y + r * sums[n].y
          local x2 = sums[j + 1].x2 - sums[i].x2 + r * sums[n].x2
          local xy = sums[j + 1].xy - sums[i].xy + r * sums[n].xy
          local y2 = sums[j + 1].y2 - sums[i].y2 + r * sums[n].y2
          local k = j + 1 - i + r * n
          ctr.x = x / k
          ctr.y = y / k
          local a = (x2 - x * x / k) / k
          local b = (xy - x * y / k) / k
          local c = (y2 - y * y / k) / k
          local lambda2 = (a + c + math.sqrt((a - c) * (a - c) + 4 * b * b)) / 2
          a = a - lambda2
          c = c - lambda2
          if (math.abs(a) >= math.abs(c)) then
            local l = math.sqrt(a * a + b * b)
            if (l ~= 0) then
              dir.x = -b / l
              dir.y = a / l
            end
          else
            local l = math.sqrt(c * c + b * b)
            if (l ~= 0) then
              dir.x = -c / l
              dir.y = b / l
            end
          end
          if (l == 0) then
            dir.x = 0
            dir.y = 0
          end
        end
        local m, po, n, pt, x0, y0 = path.m, path.po, path.len, path.pt, path.x0, path.y0
        local q, v, s, ctr, dir = { }, { }, Point(), { }, { }
        path.curve = Curve(m)
        for i = 0, m - 1 do
          local j = po[mod(i + 1, m)]
          j = mod(j - po[i], n) + po[i]
          ctr[i] = Point()
          dir[i] = Point()
          pointslope(path, po[i], j, ctr[i], dir[i])
        end
        for i = 0, m - 1 do
          q[i] = Quad()
          local d = dir[i].x * dir[i].x + dir[i].y * dir[i].y
          if (d == 0) then
            for j = 0, 2 do
              for k = 0, 2 do
                q[i].data[j * 3 + k] = 0
              end
            end
          else
            v[0] = dir[i].y
            v[1] = -dir[i].x
            v[2] = -v[1] * ctr[i].y - v[0] * ctr[i].x
            for l = 0, 2 do
              for k = 0, 2 do
                q[i].data[l * 3 + k] = v[l] * v[k] / d
              end
            end
          end
        end
        for i = 0, m - 1 do
          local _continue_0 = false
          repeat
            local Q = Quad()
            local w = Point()
            s.x = pt[po[i]].x - x0
            s.y = pt[po[i]].y - y0
            local j = mod(i - 1, m)
            for l = 0, 2 do
              for k = 0, 2 do
                Q.data[l * 3 + k] = q[j]:at(l, k) + q[i]:at(l, k)
              end
            end
            while true do
              local det = Q:at(0, 0) * Q:at(1, 1) - Q:at(0, 1) * Q:at(1, 0)
              if (det ~= 0) then
                w.x = (-Q:at(0, 2) * Q:at(1, 1) + Q:at(1, 2) * Q:at(0, 1)) / det
                w.y = (Q:at(0, 2) * Q:at(1, 0) - Q:at(1, 2) * Q:at(0, 0)) / det
                break
              end
              if (Q:at(0, 0) > Q:at(1, 1)) then
                v[0] = -Q:at(0, 1)
                v[1] = Q:at(0, 0)
              elseif (Q:at(1, 1)) ~= 0 then
                v[0] = -Q:at(1, 1)
                v[1] = Q:at(1, 0)
              else
                v[0] = 1
                v[1] = 0
              end
              local d = v[0] * v[0] + v[1] * v[1]
              v[2] = -v[1] * s.y - v[0] * s.x
              for l = 0, 2 do
                for k = 0, 2 do
                  Q.data[l * 3 + k] = Q.data[l * 3 + k] + (v[l] * v[k] / d)
                end
              end
            end
            local dx = math.abs(w.x - s.x)
            local dy = math.abs(w.y - s.y)
            if (dx <= 0.5 and dy <= 0.5) then
              path.curve.vertex[i] = Point(w.x + x0, w.y + y0)
              _continue_0 = true
              break
            end
            local min = quadform(Q, s)
            local xmin = s.x
            local ymin = s.y
            if (Q:at(0, 0) ~= 0) then
              for z = 0, 1 do
                w.y = s.y - 0.5 + z
                w.x = -(Q:at(0, 1) * w.y + Q:at(0, 2)) / Q:at(0, 0)
                dx = math.abs(w.x - s.x)
                local cand = quadform(Q, w)
                if (dx <= 0.5 and cand < min) then
                  min = cand
                  xmin = w.x
                  ymin = w.y
                end
              end
            end
            if (Q:at(1, 1) ~= 0) then
              for z = 0, 1 do
                w.x = s.x - 0.5 + z
                w.y = -(Q:at(1, 0) * w.x + Q:at(1, 2)) / Q:at(1, 1)
                dy = math.abs(w.y - s.y)
                local cand = quadform(Q, w)
                if (dy <= 0.5 and cand < min) then
                  min = cand
                  xmin = w.x
                  ymin = w.y
                end
              end
            end
            for l = 0, 2 do
              for k = 0, 2 do
                w.x = s.x - 0.5 + l
                w.y = s.y - 0.5 + k
                local cand = quadform(Q, w)
                if (cand < min) then
                  min = cand
                  xmin = w.x
                  ymin = w.y
                end
              end
            end
            path.curve.vertex[i] = Point(xmin + x0, ymin + y0)
            _continue_0 = true
          until true
          if not _continue_0 then
            break
          end
        end
      end
      local reverse
      reverse = function(path)
        local curve = path.curve
        local m, v = curve.n, curve.vertex
        local i, j = 0, m - 1
        while i < j do
          local tmp = v[i]
          v[i] = v[j]
          v[j] = tmp
          i = i + 1
          j = j - 1
        end
      end
      local smooth
      smooth = function(path)
        local m, curve, alpha = path.curve.n, path.curve
        for i = 0, m - 1 do
          local j = mod(i + 1, m)
          local k = mod(i + 2, m)
          local p4 = interval(1 / 2, curve.vertex[k], curve.vertex[j])
          local denom = ddenom(curve.vertex[i], curve.vertex[k])
          if (denom ~= 0) then
            local dd = dpara(curve.vertex[i], curve.vertex[j], curve.vertex[k]) / denom
            dd = math.abs(dd)
            alpha = dd > 1 and (1 - 1 / dd) or 0
            alpha = alpha / 0.75
          else
            alpha = 4 / 3
          end
          curve.alpha0[j] = alpha
          if (alpha >= self.info.alphamax) then
            curve.tag[j] = "CORNER"
            curve.c[3 * j + 1] = curve.vertex[j]
            curve.c[3 * j + 2] = p4
          else
            if (alpha < 0.55) then
              alpha = 0.55
            elseif (alpha > 1) then
              alpha = 1
            end
            local p2 = interval(0.5 + 0.5 * alpha, curve.vertex[i], curve.vertex[j])
            local p3 = interval(0.5 + 0.5 * alpha, curve.vertex[k], curve.vertex[j])
            curve.tag[j] = "CURVE"
            curve.c[3 * j + 0] = p2
            curve.c[3 * j + 1] = p3
            curve.c[3 * j + 2] = p4
          end
          curve.alpha[j] = alpha
          curve.beta[j] = 0.5
        end
        curve.alphacurve = 1
      end
      local optiCurve
      optiCurve = function(path)
        local Opti
        do
          local _class_1
          local _base_1 = { }
          _base_1.__index = _base_1
          _class_1 = setmetatable({
            __init = function(self)
              self.pen = 0
              self.c = {
                [0] = Point(),
                Point()
              }
              self.t = 0
              self.s = 0
              self.alpha = 0
            end,
            __base = _base_1,
            __name = "Opti"
          }, {
            __index = _base_1,
            __call = function(cls, ...)
              local _self_0 = setmetatable({}, _base_1)
              cls.__init(_self_0, ...)
              return _self_0
            end
          })
          _base_1.__class = _class_1
          Opti = _class_1
        end
        local opti_penalty
        opti_penalty = function(path, i, j, res, opttolerance, convc, areac)
          local m = path.curve.n
          local curve = path.curve
          local vertex = curve.vertex
          if (i == j) then
            return 1
          end
          local k = i
          local i1 = mod(i + 1, m)
          local k1 = mod(k + 1, m)
          local conv = convc[k1]
          if (conv == 0) then
            return 1
          end
          local d = ddist(vertex[i], vertex[i1])
          k = k1
          while k ~= j do
            k1 = mod(k + 1, m)
            local k2 = mod(k + 2, m)
            if (convc[k1] ~= conv) then
              return 1
            end
            if (sign(cprod(vertex[i], vertex[i1], vertex[k1], vertex[k2])) ~= conv) then
              return 1
            end
            if (iprod1(vertex[i], vertex[i1], vertex[k1], vertex[k2]) < d * ddist(vertex[k1], vertex[k2]) * -0.999847695156) then
              return 1
            end
            k = k1
          end
          local p0 = curve.c[mod(i, m) * 3 + 2]:copy()
          local p1 = vertex[mod(i + 1, m)]:copy()
          local p2 = vertex[mod(j, m)]:copy()
          local p3 = curve.c[mod(j, m) * 3 + 2]:copy()
          local area = areac[j] - areac[i]
          area = area - (dpara(vertex[0], curve.c[i * 3 + 2], curve.c[j * 3 + 2]) / 2)
          if (i >= j) then
            area = area + areac[m]
          end
          local A1 = dpara(p0, p1, p2)
          local A2 = dpara(p0, p1, p3)
          local A3 = dpara(p0, p2, p3)
          local A4 = A1 + A3 - A2
          if (A2 == A1) then
            return 1
          end
          local t = A3 / (A3 - A4)
          local s = A2 / (A2 - A1)
          local A = A2 * t / 2
          if (A == 0) then
            return 1
          end
          local R = area / A
          local alpha = 2 - math.sqrt(4 - R / 0.3)
          res.c[0] = interval(t * alpha, p0, p1)
          res.c[1] = interval(s * alpha, p3, p2)
          res.alpha = alpha
          res.t = t
          res.s = s
          p1 = res.c[0]:copy()
          p2 = res.c[1]:copy()
          res.pen = 0
          k = mod(i + 1, m)
          while k ~= j do
            k1 = mod(k + 1, m)
            t = tangent(p0, p1, p2, p3, vertex[k], vertex[k1])
            if (t < -0.5) then
              return 1
            end
            local pt = bezier(t, p0, p1, p2, p3)
            d = ddist(vertex[k], vertex[k1])
            if (d == 0) then
              return 1
            end
            local d1 = dpara(vertex[k], vertex[k1], pt) / d
            if (math.abs(d1) > opttolerance) then
              return 1
            end
            if (iprod(vertex[k], vertex[k1], pt) < 0 or iprod(vertex[k1], vertex[k], pt) < 0) then
              return 1
            end
            res.pen = res.pen + (d1 * d1)
            k = k1
          end
          k = i
          while k ~= j do
            k1 = mod(k + 1, m)
            t = tangent(p0, p1, p2, p3, curve.c[k * 3 + 2], curve.c[k1 * 3 + 2])
            if (t < -0.5) then
              return 1
            end
            local pt = bezier(t, p0, p1, p2, p3)
            d = ddist(curve.c[k * 3 + 2], curve.c[k1 * 3 + 2])
            if (d == 0) then
              return 1
            end
            local d1 = dpara(curve.c[k * 3 + 2], curve.c[k1 * 3 + 2], pt) / d
            local d2 = dpara(curve.c[k * 3 + 2], curve.c[k1 * 3 + 2], vertex[k1]) / d
            d2 = d2 * (0.75 * curve.alpha[k1])
            if (d2 < 0) then
              d1 = -d1
              d2 = -d2
            end
            if (d1 < d2 - opttolerance) then
              return 1
            end
            if (d1 < d2) then
              res.pen = res.pen + ((d1 - d2) * (d1 - d2))
            end
            k = k1
          end
          return 0
        end
        local curve = path.curve
        local m, vert, pt, pen, len, opt, convc, areac, o = curve.n, curve.vertex, { }, { }, { }, { }, { }, { }, Opti()
        for i = 0, m - 1 do
          if (curve.tag[i] == "CURVE") then
            convc[i] = sign(dpara(vert[mod(i - 1, m)], vert[i], vert[mod(i + 1, m)]))
          else
            convc[i] = 0
          end
        end
        local area = 0
        areac[0] = 0
        local p0 = curve.vertex[0]
        for i = 0, m - 1 do
          local i1 = mod(i + 1, m)
          if (curve.tag[i1] == "CURVE") then
            local alpha = curve.alpha[i1]
            area = area + (0.3 * alpha * (4 - alpha) * dpara(curve.c[i * 3 + 2], vert[i1], curve.c[i1 * 3 + 2]) / 2)
            area = area + (dpara(p0, curve.c[i * 3 + 2], curve.c[i1 * 3 + 2]) / 2)
          end
          areac[i + 1] = area
        end
        pt[0] = -1
        pen[0] = 0
        len[0] = 0
        for j = 1, m do
          pt[j] = j - 1
          pen[j] = pen[j - 1]
          len[j] = len[j - 1] + 1
          for i = j - 2, 0, -1 do
            local r = opti_penalty(path, i, mod(j, m), o, self.info.opttolerance, convc, areac)
            if (r == 1) then
              break
            end
            if (len[j] > len[i] + 1 or (len[j] == len[i] + 1 and pen[j] > pen[i] + o.pen)) then
              pt[j] = i
              pen[j] = pen[i] + o.pen
              len[j] = len[i] + 1
              opt[j] = o
              o = Opti()
            end
          end
        end
        local om = len[m]
        local ocurve = Curve(om)
        local s, t, j = { }, { }, m
        for i = om - 1, 0, -1 do
          if (pt[j] == j - 1) then
            ocurve.tag[i] = curve.tag[mod(j, m)]
            ocurve.c[i * 3 + 0] = curve.c[mod(j, m) * 3 + 0]
            ocurve.c[i * 3 + 1] = curve.c[mod(j, m) * 3 + 1]
            ocurve.c[i * 3 + 2] = curve.c[mod(j, m) * 3 + 2]
            ocurve.vertex[i] = curve.vertex[mod(j, m)]
            ocurve.alpha[i] = curve.alpha[mod(j, m)]
            ocurve.alpha0[i] = curve.alpha0[mod(j, m)]
            ocurve.beta[i] = curve.beta[mod(j, m)]
            s[i] = 1
            t[i] = 1
          else
            ocurve.tag[i] = "CURVE"
            ocurve.c[i * 3 + 0] = opt[j].c[0]
            ocurve.c[i * 3 + 1] = opt[j].c[1]
            ocurve.c[i * 3 + 2] = curve.c[mod(j, m) * 3 + 2]
            ocurve.vertex[i] = interval(opt[j].s, curve.c[mod(j, m) * 3 + 2], vert[mod(j, m)])
            ocurve.alpha[i] = opt[j].alpha
            ocurve.alpha0[i] = opt[j].alpha
            s[i] = opt[j].s
            t[i] = opt[j].t
          end
          j = pt[j]
        end
        for i = 0, om - 1 do
          local i1 = mod(i + 1, om)
          ocurve.beta[i] = s[i] / (s[i] + t[i1])
        end
        ocurve.alphacurve = 1
        path.curve = ocurve
      end
      for i = 0, #self.pathlist do
        local path = self.pathlist[i]
        calcSums(path)
        calcLon(path)
        bestPolygon(path)
        adjustVertices(path)
        if (path.sign == "-") then
          reverse(path)
        end
        smooth(path)
        if (self.info.optcurve) then
          optiCurve(path)
        end
      end
    end,
    getSVG = function(self, size, opt_type)
      if size == nil then
        size = 1
      end
      local fixed
      fixed = function(x, n)
        if n == nil then
          n = 3
        end
        n = 10 ^ math.floor(n)
        return math.floor(x * n + 0.5) / n
      end
      local path
      path = function(curve)
        local bezier
        bezier = function(i)
          local b = "C " .. fixed(curve.c[i * 3 + 0].x * size) .. " " .. fixed(curve.c[i * 3 + 0].y * size) .. ","
          b = b .. (fixed(curve.c[i * 3 + 1].x * size) .. " " .. fixed(curve.c[i * 3 + 1].y * size) .. ",")
          b = b .. (fixed(curve.c[i * 3 + 2].x * size) .. " " .. fixed(curve.c[i * 3 + 2].y * size) .. " ")
          return b
        end
        local segment
        segment = function(i)
          local s = "L " .. fixed(curve.c[i * 3 + 1].x * size) .. " " .. fixed(curve.c[i * 3 + 1].y * size) .. " "
          s = s .. (fixed(curve.c[i * 3 + 2].x * size) .. " " .. fixed(curve.c[i * 3 + 2].y * size) .. " ")
          return s
        end
        local n = curve.n
        local p = "M" .. fixed(curve.c[(n - 1) * 3 + 2].x * size) .. " " .. fixed(curve.c[(n - 1) * 3 + 2].y * size) .. " "
        for i = 0, n - 1 do
          if (curve.tag[i] == "CURVE") then
            p = p .. bezier(i)
          elseif (curve.tag[i] == "CORNER") then
            p = p .. segment(i)
          end
        end
        return p
      end
      local strokec, fillc, fillrule
      local w, h, len = self.bm.w * size, self.bm.h * size, #self.pathlist + 1
      local svg = '<svg id="svg" version="1.1" width="' .. w .. '" height="' .. h .. '" xmlns="http://www.w3.org/2000/svg">'
      svg = svg .. '<path d="'
      for i = 0, len - 1 do
        local c = self.pathlist[i].curve
        svg = svg .. path(c)
      end
      if (opt_type == "curve") then
        strokec = "black"
        fillc = "none"
        fillrule = ""
      else
        strokec = "none"
        fillc = "black"
        fillrule = ' fill-rule="evenodd"'
      end
      svg = svg .. ('" stroke="' .. strokec .. '" fill="' .. fillc .. '"' .. fillrule .. '/></svg>')
      return svg
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, filename)
      local data = bitmap.decode_from_file(filename)
      local w, h = data.w, data.h
      self.bm = Bitmap(w, h)
      self.info = Configs()
      self.pathlist = Path()
      data = data:map()
      for i = 0, w * h - 1 do
        local color = 0.2126 * data[i].r + 0.7153 * data[i].g + 0.0721 * data[i].b
        self.bm.data[i] = (color < 128 and 1 or 0)
      end
      return self
    end,
    __base = _base_0,
    __name = "Potrace"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Potrace = _class_0
end
return {
  Potrace = Potrace
}