#version 330 core
layout (location = 0) in vec2 a_position;
layout (location = 1) in vec3 a_color;

out vec3 v_color;

void main()
{
    gl_Position = vec4(a_position, 0.0f, 1.0f);
    v_color = a_color;
}