//
// Shader replacing 
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float range;
uniform vec4 colorMatch1;
uniform vec4 colorMatch2;
uniform vec4 colorReplace1;
uniform vec4 colorReplace2;

void main()
{
	vec4 pixelColor=v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float newRange=range/255.0;
	
	if (abs(pixelColor.r-colorMatch1.r)<=newRange) {
		if (abs(pixelColor.g-colorMatch1.g)<=newRange) {
			if (abs(pixelColor.b-colorMatch1.b)<=newRange) {
				pixelColor.rgb=colorReplace1.rgb;
			}
		}
	}
	
	if (abs(pixelColor.r-colorMatch2.r)<=newRange) {
		if (abs(pixelColor.g-colorMatch2.g)<=newRange) {
			if (abs(pixelColor.b-colorMatch2.b)<=newRange) {
				pixelColor.rgb=colorReplace2.rgb;
			}
		}
	}

    gl_FragColor = pixelColor;
}
