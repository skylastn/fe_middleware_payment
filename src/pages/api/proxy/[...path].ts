import type { NextApiRequest, NextApiResponse } from "next";
import axios, { AxiosError } from "axios";

export const config = {
  api: {
    bodyParser: {
      sizeLimit: "20mb",
    },
    responseLimit: false,
  },
};

export default async function handler(
  req: NextApiRequest,
  res: NextApiResponse,
) {
  const { path } = req.query;
  const pathSegments = Array.isArray(path) ? path : [path || ""];
  const pathStr = pathSegments.join("/");

  const backendBase = (
    process.env.NEXT_PUBLIC_API_URL ||
    process.env.API_URL ||
    "http://localhost:8000"
  ).replace(/\/+$/, "");

  const targetUrl = `${backendBase}/${pathStr}`;

  // Copy query params excluding dynamic route catch-all 'path'
  const queryParams = { ...req.query };
  delete queryParams.path;

  try {
    const headers: Record<string, string> = {
      Accept: "application/json",
    };

    if (req.headers["content-type"]) {
      headers["Content-Type"] = String(req.headers["content-type"]);
    } else {
      headers["Content-Type"] = "application/json";
    }

    // Forward client payment token header
    if (req.headers["token"]) {
      headers["Token"] = String(req.headers["token"]);
    }

    // Forward authorization header if available
    if (req.headers["authorization"]) {
      headers["Authorization"] = String(req.headers["authorization"]);
    }

    const response = await axios({
      method: req.method,
      url: targetUrl,
      params: Object.keys(queryParams).length > 0 ? queryParams : undefined,
      data:
        req.method !== "GET" && req.method !== "HEAD" ? req.body : undefined,
      headers,
      validateStatus: () => true,
      timeout: 35000,
    });

    res.status(response.status).json(response.data);
  } catch (error: unknown) {
    const err = error as AxiosError;
    const statusCode = err.response?.status || 500;
    const responseData = err.response?.data || {
      status: false,
      message: err.message || "Proxy request to backend failed",
    };

    res.status(statusCode).json(responseData);
  }
}
