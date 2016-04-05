Vector2 = require 'Vector2'

function finishCasting()
	local current = Vector2:new(getOwnerX(), getOwnerY())
	local to = (Vector2:new(getSpellToX(), getSpellToY()) - current):normalize()
	local range = to * 900
	local trueCoords = current + range
	addServerProjectile(trueCoords.x, trueCoords.y)
end

function applyEffects()
	dealMagicalDamage(getEffectValue(0))
	-- addParticleTarget("dr_mundo_infected_cleaver_tar.troy", getTarget()) not visible, dk where to find this
	destroyProjectile()
	-- add slow
end