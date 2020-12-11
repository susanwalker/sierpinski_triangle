defmodule SierpinskiTriangle do
  def draw(k) do
    initialize_image()
    |> initialize_triangle()
    |> divide_triangles(k)
    |> draw_image()
    |> save_image()
  end

  defp initialize_image do
    %SierpinskiTriangle.Image{}
  end

  defp initialize_triangle(image = %SierpinskiTriangle.Image{width: width}) do
    triangle = %SierpinskiTriangle.Triangle{
      x1: div(width, 2),
      y1: 0,
      x2: 0,
      y2: width,
      x3: width,
      y3: width
    }

    %SierpinskiTriangle.Image{image | triangles: [triangle]}
  end

  #
  defp divide_triangles(image, 0) do
    image
  end

  defp divide_triangles(image, k) do
    triangles =
      image.triangles
      |> Enum.map(&get_divisions/1)
      |> List.flatten()

    image = %SierpinskiTriangle.Image{image | triangles: triangles}
    divide_triangles(image, k - 1)
  end

  defp get_divisions(parent_triangle) do
    [
      %SierpinskiTriangle.Triangle{
        x1: parent_triangle.x1,
        y1: parent_triangle.y1,
        x2: div((parent_triangle.x1 - parent_triangle.x2), 2) + parent_triangle.x2,
        y2: div((parent_triangle.y2 - parent_triangle.y1), 2) + parent_triangle.y1,
        x3: div((parent_triangle.x3 - parent_triangle.x1), 2) + parent_triangle.x1,
        y3: div((parent_triangle.y3 - parent_triangle.y1), 2) + parent_triangle.y1
      },
      %SierpinskiTriangle.Triangle{
        x1: div((parent_triangle.x1 - parent_triangle.x2), 2) + parent_triangle.x2,
        y1: div((parent_triangle.y2 - parent_triangle.y1), 2) + parent_triangle.y1,
        x2: parent_triangle.x2,
        y2: parent_triangle.y2,
        x3: div((parent_triangle.x3 - parent_triangle.x2), 2) + parent_triangle.x2,
        y3: parent_triangle.y3
      },
      %SierpinskiTriangle.Triangle{
        x1: div((parent_triangle.x3 - parent_triangle.x1), 2) + parent_triangle.x1,
        y1: div((parent_triangle.y3 - parent_triangle.y1), 2) + parent_triangle.y1,
        x2: div((parent_triangle.x3 - parent_triangle.x2), 2) + parent_triangle.x2,
        y2: parent_triangle.y3,
        x3: parent_triangle.x3,
        y3: parent_triangle.y3
      }
    ]
  end

  defp draw_image(%SierpinskiTriangle.Image{width: width, triangles: triangles}) do
    area = :egd.create(width + 10, width + 10)
    fill = :egd.color({0, 0, 0})
    draw_triangles(area, fill, triangles)
    :egd.render(area)
  end

  defp draw_triangles(area, fill, triangles) do
    IO.inspect triangles, label: "image triangles"
    Enum.each(triangles, fn(t) ->
      :egd.filledTriangle(
        area,
        {t.x1, t.y1}, {t.x2, t.y2}, {t.x3, t.y3},
        fill
      )
    end)
  end

  defp save_image(image) do
    File.write("test.png", image)
  end
end
