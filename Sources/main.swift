import CGLFW3
import SGLOpenGL
import Glibc

// Window dimensions
let WIDTH:GLsizei = 800, HEIGHT:GLsizei = 600

// The *main* function; where our program begins running
func main()
{
    print("Starting GLFW context, OpenGL 3.3")
    // Init GLFW
    glfwInit()
    // Terminate GLFW when this function ends
    defer { glfwTerminate() }

    // Set all the required options for GLFW
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
    glfwWindowHint(GLFW_RESIZABLE, GL_FALSE)
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE)

    // Create a GLFWwindow object that we can use for GLFW's functions
    let window = glfwCreateWindow(WIDTH, HEIGHT, "Korstin has a long way to go but fronk believes she cen sev the wlord", nil, nil)
    glfwMakeContextCurrent(window)
    guard window != nil else
    {
        print("Failed to create GLFW window")
        return
    }

    // Set the required callback functions
    glfwSetKeyCallback(window, keyCallback)

    // Define the viewport dimensions
    glViewport(x: 0, y: 0, width: WIDTH, height: HEIGHT)

    guard let ourShader = Shader(vertexFile: "basic.vert", fragmentFile: "basic.frag") else { return }

    var vertices: [GLfloat] = []
    var colors: [GLfloat] = []

    typealias Color = Int
    func drawSquare(x: Float, y: Float, size: Float, color: Color) {
        let halfSize = GLfloat(size / 2)
        let x = GLfloat(x)
        let y = GLfloat(y)
        let newVertices: [GLfloat] = [
            x - halfSize, y + halfSize,
            x - halfSize, y - halfSize,
            x + halfSize, y + halfSize,
            x - halfSize, y - halfSize,
            x + halfSize, y + halfSize,
            x + halfSize, y - halfSize,
        ]
        let newColors: [GLfloat] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0,
            1.0, 1.0, 0.0,
        ]
        vertices.append(contentsOf: newVertices)
        colors.append(contentsOf: newColors)
    }

    drawSquare(x: 0, y: 0, size: 0.05, color: 0)
    drawSquare(x: -0.5, y: 0.5, size: 0.25, color: 0)
    drawSquare(x: 0.5, y: 0.5, size: 0.25, color: 0)
    drawSquare(x: -0.75, y: -0.25, size: 0.25, color: 0)
    drawSquare(x: -0.45, y: -0.35, size: 0.25, color: 0)
    drawSquare(x: 0.0, y: -0.55, size: 0.25, color: 0)
    drawSquare(x: 0.45, y: -0.35, size: 0.25, color: 0)
    drawSquare(x: 0.75, y: -0.25, size: 0.25, color: 0)
    ///////

    // Create vertices vertex array
    var vertexArray: GLuint = 0
    glGenVertexArrays(n: 1, arrays: &vertexArray)
    defer { glDeleteVertexArrays(1, &vertexArray) }
    var VBO: GLuint = 0
    glGenBuffers(n: 1, buffers: &VBO)
    defer { glDeleteBuffers(1, &VBO) }
    var VBO2: GLuint = 0
    glGenBuffers(n: 1, buffers: &VBO2)
    defer { glDeleteBuffers(1, &VBO2) }

    glBindVertexArray(vertexArray)
    glBindBuffer(target: GL_ARRAY_BUFFER, buffer: VBO)
    glBufferData(target: GL_ARRAY_BUFFER,
            size: MemoryLayout<GLfloat>.stride * vertices.count,
            data: vertices, usage: GL_STATIC_DRAW)

    glVertexAttribPointer(index: 0, size: 2, type: GL_FLOAT,
            normalized: false, stride: GLsizei(MemoryLayout<GLfloat>.stride * 2), pointer: nil)
    glEnableVertexAttribArray(0)


    glBindBuffer(target: GL_ARRAY_BUFFER, buffer: VBO2)
    glBufferData(target: GL_ARRAY_BUFFER,
            size: MemoryLayout<GLfloat>.stride * colors.count,
            data: colors, usage: GL_STATIC_DRAW)

    glVertexAttribPointer(index: 1, size: 3, type: GL_FLOAT,
            normalized: false, stride: GLsizei(MemoryLayout<GLfloat>.stride * 3), pointer: nil)
    glEnableVertexAttribArray(1)

    glBindBuffer(target: GL_ARRAY_BUFFER, buffer: 0)
    glBindVertexArray(0)
    //////

    // Game loop
    while glfwWindowShouldClose(window) == GL_FALSE
    {
        // Check if any events have been activated
        // (key pressed, mouse moved etc.) and call
        // the corresponding response functions
        glfwPollEvents()

        // Render
        // Clear the colorbuffer
        // 139,0,139
        glClearColor(red: 139 / 255.0, green: 0, blue: 139 / 255.0, alpha: 1.0)
        glClear(GL_COLOR_BUFFER_BIT)

        ourShader.use()
        glBindVertexArray(vertexArray)
        glDrawArrays(GL_TRIANGLES, 0, GLsizei(vertices.count))
        glBindVertexArray(0)

        // Swap the screen buffers
        glfwSwapBuffers(window)
    }
}

// called whenever a key is pressed/released via GLFW
func keyCallback(window: OpaquePointer!, key: Int32, scancode: Int32, action: Int32, mode: Int32) {
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, GL_TRUE)
    }
}

// Start the program with function main()
main()