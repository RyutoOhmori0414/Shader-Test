using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeController : MonoBehaviour
{
    const float error = 1e-8f;

    public static void BakeNormal(GameObject obj)
    {
        var meshFilters = obj.GetComponentsInChildren<MeshFilter>();

        foreach (var meshFilter in meshFilters)
        {

            var mesh = meshFilter.sharedMesh;

            var normals = mesh.normals;
            var vertices = mesh.vertices;
            var vertexCount = mesh.vertexCount;

            Color[] softEdges = new Color[normals.Length];

            for (int i = 0; i < vertexCount; i++)
            {
                Vector3 softEdge = Vector3.zero;

                for (int j = 0; j < vertexCount; j++)
                {
                    var v = vertices[i] - vertices[j];

                    if (v.sqrMagnitude < error)
                    {
                        softEdge += normals[j];
                    }
                }

                softEdge.Normalize();

                softEdges[i] = new Color(softEdge.x, softEdge.y, softEdge.z, 0);
            }

            mesh.colors = softEdges;

        }

    }
}
